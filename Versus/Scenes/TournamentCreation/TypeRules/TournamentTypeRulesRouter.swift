//
//  TournamentTypeRulesRouter.swift
//  Versus
//

import UIKit

protocol TournamentTypeRulesRoutingLogic {
    func routeToPlayers()
}

final class TournamentTypeRulesRouter: BaseRouter, TournamentTypeRulesRoutingLogic {
    weak var viewController: TournamentTypeRulesViewController?
    var draft: TournamentCreationDraft?

    func routeToPlayers() {
        guard let viewController, let draft else { return }
        let next = SceneFactory.makeTournamentPlayersScene(draft: draft)
        navigate(to: next, from: viewController, style: .push)
    }
}
