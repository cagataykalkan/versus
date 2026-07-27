//
//  FriendsPresenter.swift
//  Versus
//

import Foundation

protocol FriendsPresentationLogic {
    func presentLoad(response: Friends.Load.Response)
    func presentSearch(response: Friends.Search.Response)
    func presentSendRequest(response: Friends.SendRequest.Response)
    func presentAcceptRequest(response: Friends.AcceptRequest.Response)
}

final class FriendsPresenter: FriendsPresentationLogic {
    weak var viewController: FriendsDisplayLogic?

    func presentLoad(response: Friends.Load.Response) {
        let friends = (try? response.friends.get()) ?? []
        let pending = (try? response.pendingRequests.get()) ?? []
        viewController?.displayLoad(viewModel: .init(friends: friends, pendingRequests: pending))
    }

    func presentSearch(response: Friends.Search.Response) {
        let results = (try? response.result.get()) ?? []
        viewController?.displaySearch(viewModel: .init(results: results))
    }

    func presentSendRequest(response: Friends.SendRequest.Response) {
        switch response.result {
        case .success:
            viewController?.displaySendRequest(viewModel: .init(message: "İstek gönderildi."))
        case .failure(let error):
            viewController?.displaySendRequest(viewModel: .init(message: error.localizedDescription))
        }
    }

    func presentAcceptRequest(response: Friends.AcceptRequest.Response) {
        switch response.result {
        case .success:
            viewController?.displayAcceptRequest(viewModel: .init(message: nil))
        case .failure(let error):
            viewController?.displayAcceptRequest(viewModel: .init(message: error.localizedDescription))
        }
    }
}
