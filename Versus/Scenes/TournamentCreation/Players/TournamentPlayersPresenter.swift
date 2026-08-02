//
//  TournamentPlayersPresenter.swift
//  Versus
//

import Foundation

protocol TournamentPlayersPresentationLogic {
    func presentLoad(response: TournamentPlayers.Load.Response)
    func presentContinue(response: TournamentPlayers.Continue.Response)
}

final class TournamentPlayersPresenter: TournamentPlayersPresentationLogic {
    weak var viewController: TournamentPlayersDisplayLogic?

    func presentLoad(response: TournamentPlayers.Load.Response) {
        let currentUser = try? response.currentUser.get()
        let friends = (try? response.friends.get()) ?? []
        viewController?.displayLoad(viewModel: .init(currentUser: currentUser, friends: friends))
    }

    func presentContinue(response: TournamentPlayers.Continue.Response) {
        viewController?.displayContinue(viewModel: .init(errorMessage: response.errorMessage))
    }
}
