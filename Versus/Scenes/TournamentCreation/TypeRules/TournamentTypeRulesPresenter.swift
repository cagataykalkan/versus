//
//  TournamentTypeRulesPresenter.swift
//  Versus
//

import Foundation

protocol TournamentTypeRulesPresentationLogic {
    func presentDefaults(response: TournamentTypeRules.Load.Response)
    func presentSave(response: TournamentTypeRules.Save.Response)
}

final class TournamentTypeRulesPresenter: TournamentTypeRulesPresentationLogic {
    weak var viewController: TournamentTypeRulesDisplayLogic?

    func presentDefaults(response: TournamentTypeRules.Load.Response) {
        let rules = response.rules
        viewController?.displayDefaults(viewModel: .init(
            type: response.type,
            drawAllowed: rules.drawAllowed,
            rematchAllowed: rules.rematchAllowed,
            doubleRound: rules.doubleRound,
            matchFormat: rules.matchFormat,
            pointsWin: rules.pointsWin,
            pointsDraw: rules.pointsDraw,
            pointsLoss: rules.pointsLoss
        ))
    }

    func presentSave(response: TournamentTypeRules.Save.Response) {
        viewController?.displaySave(viewModel: .init())
    }
}
