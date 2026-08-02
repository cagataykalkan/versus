//
//  TournamentListRouter.swift
//  Versus
//

import UIKit

protocol TournamentListRoutingLogic {
    func routeToCreateTournament()
}

final class TournamentListRouter: BaseRouter, TournamentListRoutingLogic {
    weak var viewController: TournamentListViewController?

    func routeToCreateTournament() {
        guard let viewController else { return }
        let next = SceneFactory.makeTournamentBasicsScene()
        navigate(to: next, from: viewController, style: .push)
    }
}
