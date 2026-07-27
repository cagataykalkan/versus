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
        let usernameLower = username.lowercased()

        // The username-uniqueness write requires an authenticated request (see firestore.rules),
        // so the Firebase Auth account must exist — and be signed in — before it is reserved.
        let uid: String
        do {
            uid = try await Auth.auth().createUser(withEmail: email, password: password).user.uid
        } catch {
            throw WorkerError.underlying(error.localizedDescription)
        }

        do {
            let reserved = try await reserveUsername(usernameLower, for: uid)
            guard reserved else {
                try? await Auth.auth().currentUser?.delete()
                throw WorkerError.usernameTaken
            }

            try await firestore.collection("users").document(uid).setData([
                "username": username,
                "usernameLower": usernameLower,
                "email": email,
                "createdAt": FieldValue.serverTimestamp()
            ])

            return AppUser(id: uid, username: username, email: email, photoURL: nil)
        } catch let error as WorkerError {
            throw error
        } catch {
            try? await Auth.auth().currentUser?.delete()
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func signIn(email: String, password: String) async throws -> AppUser {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return try await fetchUser(uid: result.user.uid)
        } catch let error as WorkerError {
            throw error
        } catch {
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func fetchCurrentUser() async throws -> AppUser {
        guard let uid = currentUserId else {
            throw WorkerError.notAuthenticated
        }
        return try await fetchUser(uid: uid)
    }

    func updateUsername(_ newUsername: String) async throws -> AppUser {
        guard let uid = currentUserId else {
            throw WorkerError.notAuthenticated
        }

        let currentUser = try await fetchUser(uid: uid)
        let newUsernameLower = newUsername.lowercased()
        let oldUsernameLower = currentUser.username.lowercased()

        guard newUsernameLower != oldUsernameLower else {
            try await firestore.collection("users").document(uid).updateData(["username": newUsername])
            return AppUser(id: uid, username: newUsername, email: currentUser.email, photoURL: currentUser.photoURL)
        }

        do {
            let reserved = try await reserveUsername(newUsernameLower, for: uid)
            guard reserved else {
                throw WorkerError.usernameTaken
            }

            try await firestore.collection("users").document(uid).updateData([
                "username": newUsername,
                "usernameLower": newUsernameLower
            ])
            try? await firestore.collection("usernames").document(oldUsernameLower).delete()

            return AppUser(id: uid, username: newUsername, email: currentUser.email, photoURL: currentUser.photoURL)
        } catch let error as WorkerError {
            throw error
        } catch {
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
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
