//
//  TournamentTypeRulesInteractor.swift
//  Versus
//

import Foundation

protocol TournamentTypeRulesBusinessLogic {
    func loadDefaults(request: TournamentTypeRules.Load.Request)
    func save(request: TournamentTypeRules.Save.Request)
}

final class TournamentTypeRulesInteractor: TournamentTypeRulesBusinessLogic {
    var presenter: TournamentTypeRulesPresentationLogic?
    let draft: TournamentCreationDraft

    init(draft: TournamentCreationDraft) {
        self.draft = draft
    }

    func loadDefaults(request: TournamentTypeRules.Load.Request) {
        presenter?.presentDefaults(response: .init(type: draft.type, rules: draft.rules))
    }

    func save(request: TournamentTypeRules.Save.Request) {
        draft.type = request.type
        draft.rules = TournamentRules(
            drawAllowed: request.drawAllowed,
            rematchAllowed: request.rematchAllowed,
            doubleRound: request.doubleRound,
            matchFormat: request.matchFormat,
            pointsWin: request.pointsWin,
            pointsDraw: request.pointsDraw,
            pointsLoss: request.pointsLoss
        )
        presenter?.presentSave(response: .init())
    }
}
