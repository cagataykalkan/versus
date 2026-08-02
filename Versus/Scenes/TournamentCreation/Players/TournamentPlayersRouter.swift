//
//  TournamentPlayersRouter.swift
//  Versus
//

import UIKit

protocol TournamentPlayersRoutingLogic {
    func routeToReview()
}

final class TournamentPlayersRouter: BaseRouter, TournamentPlayersRoutingLogic {
    weak var viewController: TournamentPlayersViewController?
    var draft: TournamentCreationDraft?

    func routeToReview() {
        guard let viewController, let draft else { return }
        let next = SceneFactory.makeTournamentReviewScene(draft: draft)
        navigate(to: next, from: viewController, style: .push)
    }
}
