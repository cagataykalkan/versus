//
//  FirebaseFriendWorker.swift
//  Versus
//

import FirebaseAuth
import FirebaseFirestore

final class FirebaseFriendWorker: FriendWorkerProtocol {
    private let firestore = Firestore.firestore()

    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    func searchUsers(usernamePrefix: String) async throws -> [AppUser] {
        Log.request("FriendWorker.searchUsers prefix=\(usernamePrefix)")
        guard let uid = currentUserId else {
            Log.response("FriendWorker.searchUsers failed: not authenticated")
            throw WorkerError.notAuthenticated
        }

        let prefixLower = usernamePrefix.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !prefixLower.isEmpty else { return [] }
        let upperBound = prefixLower + "\u{f8ff}"

        do {
            let snapshot = try await firestore.collection("users")
                .whereField("usernameLower", isGreaterThanOrEqualTo: prefixLower)
                .whereField("usernameLower", isLessThan: upperBound)
                .limit(to: 20)
                .getDocuments()

            let results = snapshot.documents.compactMap { document -> AppUser? in
                guard document.documentID != uid else { return nil }
                return Self.makeUser(id: document.documentID, data: document.data())
            }
            Log.response("FriendWorker.searchUsers succeeded count=\(results.count)")
            return results
        } catch {
            Log.response("FriendWorker.searchUsers failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func sendFriendRequest(to userId: String) async throws {
        Log.request("FriendWorker.sendFriendRequest to=\(userId)")
        guard let uid = currentUserId, uid != userId else {
            Log.response("FriendWorker.sendFriendRequest failed: invalid request")
            throw WorkerError.underlying("Geçersiz istek.")
        }

        let ref = firestore.collection("friendships").document(Self.friendshipId(uid, userId))
        do {
            let snapshot = try await ref.getDocument()
            if let status = snapshot.data()?["status"] as? String {
                Log.response("FriendWorker.sendFriendRequest failed: existing status=\(status)")
                throw WorkerError.underlying(status == "accepted" ? "Zaten arkadaşsınız." : "İstek zaten gönderilmiş.")
            }
            try await ref.setData([
                "userIds": [uid, userId].sorted(),
                "status": "pending",
                "requestedBy": uid,
                "createdAt": FieldValue.serverTimestamp()
            ])
            Log.response("FriendWorker.sendFriendRequest succeeded")
        } catch let error as WorkerError {
            throw error
        } catch {
            Log.response("FriendWorker.sendFriendRequest failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func acceptFriendRequest(from userId: String) async throws {
        Log.request("FriendWorker.acceptFriendRequest from=\(userId)")
        guard let uid = currentUserId else {
            Log.response("FriendWorker.acceptFriendRequest failed: not authenticated")
            throw WorkerError.notAuthenticated
        }
        let ref = firestore.collection("friendships").document(Self.friendshipId(uid, userId))
        do {
            try await ref.updateData(["status": "accepted"])
            Log.response("FriendWorker.acceptFriendRequest succeeded")
        } catch {
            Log.response("FriendWorker.acceptFriendRequest failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func fetchFriends() async throws -> [AppUser] {
        Log.request("FriendWorker.fetchFriends")
        guard let uid = currentUserId else {
            Log.response("FriendWorker.fetchFriends failed: not authenticated")
            throw WorkerError.notAuthenticated
        }
        do {
            let snapshot = try await firestore.collection("friendships")
                .whereField("userIds", arrayContains: uid)
                .whereField("status", isEqualTo: "accepted")
                .getDocuments()

            let otherIds = snapshot.documents.compactMap { document -> String? in
                (document.data()["userIds"] as? [String])?.first(where: { $0 != uid })
            }
            let users = try await fetchUsers(ids: otherIds)
            Log.response("FriendWorker.fetchFriends succeeded count=\(users.count)")
            return users
        } catch {
            Log.response("FriendWorker.fetchFriends failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    func fetchPendingRequests() async throws -> [AppUser] {
        Log.request("FriendWorker.fetchPendingRequests")
        guard let uid = currentUserId else {
            Log.response("FriendWorker.fetchPendingRequests failed: not authenticated")
            throw WorkerError.notAuthenticated
        }
        do {
            let snapshot = try await firestore.collection("friendships")
                .whereField("userIds", arrayContains: uid)
                .whereField("status", isEqualTo: "pending")
                .getDocuments()

            let incomingIds = snapshot.documents.compactMap { document -> String? in
                let data = document.data()
                guard let requestedBy = data["requestedBy"] as? String, requestedBy != uid else { return nil }
                return (data["userIds"] as? [String])?.first(where: { $0 != uid })
            }
            let users = try await fetchUsers(ids: incomingIds)
            Log.response("FriendWorker.fetchPendingRequests succeeded count=\(users.count)")
            return users
        } catch {
            Log.response("FriendWorker.fetchPendingRequests failed: \(error.localizedDescription)")
            throw WorkerError.underlying(error.localizedDescription)
        }
    }

    private func fetchUsers(ids: [String]) async throws -> [AppUser] {
        try await withThrowingTaskGroup(of: AppUser?.self) { group in
            for id in ids {
                group.addTask {
                    let snapshot = try await self.firestore.collection("users").document(id).getDocument()
                    guard let data = snapshot.data() else { return nil }
                    return Self.makeUser(id: id, data: data)
                }
            }
            var users: [AppUser] = []
            for try await user in group {
                if let user { users.append(user) }
            }
            return users
        }
    }

    private static func makeUser(id: String, data: [String: Any]) -> AppUser? {
        guard let username = data["username"] as? String, let email = data["email"] as? String else { return nil }
        return AppUser(id: id, username: username, email: email, photoURL: nil)
    }

    private static func friendshipId(_ uidA: String, _ uidB: String) -> String {
        [uidA, uidB].sorted().joined(separator: "_")
    }
}
