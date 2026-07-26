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
        let usernameRef = firestore.collection("usernames").document(usernameLower)

        let isAvailable = (try? await firestore.runTransaction { transaction, errorPointer -> Any? in
            let snapshot: DocumentSnapshot
            do {
                snapshot = try transaction.getDocument(usernameRef)
            } catch {
                errorPointer?.pointee = error as NSError
                return false
            }
            if snapshot.exists {
                return false
            }
            transaction.setData(["reservedAt": FieldValue.serverTimestamp()], forDocument: usernameRef)
            return true
        }) as? Bool ?? false

        guard isAvailable else {
            throw WorkerError.usernameTaken
        }

        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid

            try await usernameRef.setData(["userId": uid], merge: true)
            try await firestore.collection("users").document(uid).setData([
                "username": username,
                "usernameLower": usernameLower,
                "email": email,
                "createdAt": FieldValue.serverTimestamp()
            ])

            return AppUser(id: uid, username: username, email: email, photoURL: nil)
        } catch {
            try? await usernameRef.delete()
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

    func signOut() throws {
        try Auth.auth().signOut()
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
