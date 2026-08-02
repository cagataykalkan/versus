//
//  TournamentReviewRouter.swift
//  Versus
//

import UIKit

protocol TournamentReviewRoutingLogic {
    func routeToTournamentList()
}

final class TournamentReviewRouter: BaseRouter, TournamentReviewRoutingLogic {
    weak var viewController: TournamentReviewViewController?

    func routeToTournamentList() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
