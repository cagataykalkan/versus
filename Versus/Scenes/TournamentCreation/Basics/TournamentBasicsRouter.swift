//
//  TournamentBasicsRouter.swift
//  Versus
//

import UIKit

protocol TournamentBasicsRoutingLogic {
    func routeToTypeRules()
}

final class TournamentBasicsRouter: BaseRouter, TournamentBasicsRoutingLogic {
    weak var viewController: TournamentBasicsViewController?
    var draft: TournamentCreationDraft?

    func routeToTypeRules() {
        guard let viewController, let draft else { return }
        let next = SceneFactory.makeTournamentTypeRulesScene(draft: draft)
        navigate(to: next, from: viewController, style: .push)
    }
}
