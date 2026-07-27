//
//  FriendsInteractor.swift
//  Versus
//

import Foundation

protocol FriendsBusinessLogic {
    func loadFriends(request: Friends.Load.Request)
    func search(request: Friends.Search.Request)
    func sendRequest(request: Friends.SendRequest.Request)
    func acceptRequest(request: Friends.AcceptRequest.Request)
}

final class FriendsInteractor: FriendsBusinessLogic {
    var presenter: FriendsPresentationLogic?
    var worker: FriendWorkerProtocol = FirebaseFriendWorker()

    func loadFriends(request: Friends.Load.Request) {
        Task {
            async let friendsResult = result { try await self.worker.fetchFriends() }
            async let pendingResult = result { try await self.worker.fetchPendingRequests() }
            let response = await Friends.Load.Response(friends: friendsResult, pendingRequests: pendingResult)
            presenter?.presentLoad(response: response)
        }
    }

    func search(request: Friends.Search.Request) {
        Task {
            let response = await Friends.Search.Response(result: result { try await self.worker.searchUsers(usernamePrefix: request.query) })
            presenter?.presentSearch(response: response)
        }
    }

    func sendRequest(request: Friends.SendRequest.Request) {
        Task {
            let response = await Friends.SendRequest.Response(result: result { try await self.worker.sendFriendRequest(to: request.userId) })
            presenter?.presentSendRequest(response: response)
        }
    }

    func acceptRequest(request: Friends.AcceptRequest.Request) {
        Task {
            let response = await Friends.AcceptRequest.Response(result: result { try await self.worker.acceptFriendRequest(from: request.userId) })
            presenter?.presentAcceptRequest(response: response)
            loadFriends(request: .init())
        }
    }

    private func result<T>(_ operation: () async throws -> T) async -> Result<T, Error> {
        do {
            return .success(try await operation())
        } catch {
            return .failure(error)
        }
    }
}
