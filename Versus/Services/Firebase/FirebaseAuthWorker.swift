//
//  FirebaseAuthWorker.swift
//  Versus
//

import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthWorker: AuthWorkerProtocol {
    private let firestore = Firestore.firestore()

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    func signUp(email: String, password: String, username: String) async throws -> AppUser {
        Log.request("AuthWorker.signUp email=\(email) username=\(username)")
        let usernameLower = username.lowercased()

        // The username-uniqueness write requires an authenticated request (see firestore.rules),
        // so the Firebase Auth account must exist — and be signed in — before it is reserved.
        let uid: String
        do {
            uid = try await Auth.auth().createUser(withEmail: email, password: password).user.uid
        } catch {
            Log.response("AuthWorker.signUp failed at createUser: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }

        do {
            let reserved = try await reserveUsername(usernameLower, for: uid)
            guard reserved else {
                try? await Auth.auth().currentUser?.delete()
                Log.response("AuthWorker.signUp failed: username \"\(username)\" already taken")
                throw WorkerError.usernameTaken
            }

            try await firestore.collection("users").document(uid).setData([
                "username": username,
                "usernameLower": usernameLower,
                "email": email,
                "createdAt": FieldValue.serverTimestamp()
            ])

            Log.response("AuthWorker.signUp succeeded uid=\(uid)")
            return AppUser(id: uid, username: username, email: email, photoURL: nil)
        } catch let error as WorkerError {
            Log.response("AuthWorker.signUp failed: \(error.localizedDescription)")
            throw error
        } catch {
            try? await Auth.auth().currentUser?.delete()
            Log.response("AuthWorker.signUp failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func signIn(email: String, password: String) async throws -> AppUser {
        Log.request("AuthWorker.signIn email=\(email)")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = try await fetchUser(uid: result.user.uid)
            Log.response("AuthWorker.signIn succeeded uid=\(user.id) username=\(user.username)")
            return user
        } catch let error as WorkerError {
            Log.response("AuthWorker.signIn failed: \(error.localizedDescription)")
            throw error
        } catch {
            Log.response("AuthWorker.signIn failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func fetchCurrentUser() async throws -> AppUser {
        Log.request("AuthWorker.fetchCurrentUser")
        guard let uid = currentUserId else {
            Log.response("AuthWorker.fetchCurrentUser failed: not authenticated")
            throw WorkerError.notAuthenticated
        }
        let user = try await fetchUser(uid: uid)
        Log.response("AuthWorker.fetchCurrentUser succeeded username=\(user.username)")
        return user
    }

    func updateUsername(_ newUsername: String) async throws -> AppUser {
        Log.request("AuthWorker.updateUsername newUsername=\(newUsername)")
        guard let uid = currentUserId else {
            Log.response("AuthWorker.updateUsername failed: not authenticated")
            throw WorkerError.notAuthenticated
        }

        let currentUser = try await fetchUser(uid: uid)
        let newUsernameLower = newUsername.lowercased()
        let oldUsernameLower = currentUser.username.lowercased()

        guard newUsernameLower != oldUsernameLower else {
            try await firestore.collection("users").document(uid).updateData(["username": newUsername])
            Log.response("AuthWorker.updateUsername succeeded (casing only) username=\(newUsername)")
            return AppUser(id: uid, username: newUsername, email: currentUser.email, photoURL: currentUser.photoURL)
        }

        do {
            let reserved = try await reserveUsername(newUsernameLower, for: uid)
            guard reserved else {
                Log.response("AuthWorker.updateUsername failed: username \"\(newUsername)\" already taken")
                throw WorkerError.usernameTaken
            }

            try await firestore.collection("users").document(uid).updateData([
                "username": newUsername,
                "usernameLower": newUsernameLower
            ])
            try? await firestore.collection("usernames").document(oldUsernameLower).delete()

            Log.response("AuthWorker.updateUsername succeeded username=\(newUsername)")
            return AppUser(id: uid, username: newUsername, email: currentUser.email, photoURL: currentUser.photoURL)
        } catch let error as WorkerError {
            Log.response("AuthWorker.updateUsername failed: \(error.localizedDescription)")
            throw error
        } catch {
            Log.response("AuthWorker.updateUsername failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func signOut() throws {
        Log.request("AuthWorker.signOut")
        do {
            try Auth.auth().signOut()
            Log.response("AuthWorker.signOut succeeded")
        } catch {
            Log.response("AuthWorker.signOut failed: \(error.localizedDescription)")
            throw error
        }
    }

    /// Reserves `usernames/{usernameLower}` for `uid` if it isn't already taken.
    /// Returns `false` if the name is already reserved; throws for any other failure.
    private func reserveUsername(_ usernameLower: String, for uid: String) async throws -> Bool {
        let usernameRef = firestore.collection("usernames").document(usernameLower)
        let result = try await firestore.runTransaction { transaction, errorPointer -> Any? in
            let snapshot: DocumentSnapshot
            do {
                snapshot = try transaction.getDocument(usernameRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            if snapshot.exists {
                return false
            }
            transaction.setData(["userId": uid, "reservedAt": FieldValue.serverTimestamp()], forDocument: usernameRef)
            return true
        }
        return result as? Bool == true
    }

    private func fetchUser(uid: String) async throws -> AppUser {
        let snapshot = try await firestore.collection("users").document(uid).getDocument()
        guard let data = snapshot.data(),
              let username = data["username"] as? String,
              let email = data["email"] as? String else {
            throw WorkerError.underlying("Kullanıcı bilgisi okunamadı.")
        }
        return AppUser(id: uid, username: username, email: email, photoURL: nil)
    }
}
