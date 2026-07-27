//
//  FriendWorkerProtocol.swift
//  Versus
//

import Foundation

protocol FriendWorkerProtocol {
    func searchUsers(usernamePrefix: String) async throws -> [AppUser]
    func sendFriendRequest(to userId: String) async throws
    func acceptFriendRequest(from userId: String) async throws
    func fetchFriends() async throws -> [AppUser]
    func fetchPendingRequests() async throws -> [AppUser]
}
