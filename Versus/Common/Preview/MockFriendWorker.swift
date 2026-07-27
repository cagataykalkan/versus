//
//  MockFriendWorker.swift
//  Versus
//

#if DEBUG
final class MockFriendWorker: FriendWorkerProtocol {
    var searchResults: [AppUser] = [
        AppUser(id: "search-1", username: "mehmet", email: "mehmet@example.com", photoURL: nil)
    ]
    var friends: [AppUser] = [
        AppUser(id: "friend-1", username: "ali", email: "ali@example.com", photoURL: nil)
    ]
    var pendingRequests: [AppUser] = [
        AppUser(id: "pending-1", username: "ayse", email: "ayse@example.com", photoURL: nil)
    ]

    func searchUsers(usernamePrefix: String) async throws -> [AppUser] { searchResults }
    func sendFriendRequest(to userId: String) async throws {}
    func acceptFriendRequest(from userId: String) async throws {}
    func fetchFriends() async throws -> [AppUser] { friends }
    func fetchPendingRequests() async throws -> [AppUser] { pendingRequests }
}
#endif
