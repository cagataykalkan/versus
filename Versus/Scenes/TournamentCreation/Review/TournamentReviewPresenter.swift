//
//  TournamentReviewPresenter.swift
//  Versus
//

import Foundation

protocol TournamentReviewPresentationLogic {
    func presentSummary(draft: TournamentCreationDraft)
    func presentCreate(response: TournamentReview.Create.Response)
}

final class TournamentReviewPresenter: TournamentReviewPresentationLogic {
    weak var viewController: TournamentReviewDisplayLogic?

    func presentSummary(draft: TournamentCreationDraft) {
        let rules = draft.rules
        let rulesLines = [
            rules.drawAllowed ? "Beraberlik: Var" : "Beraberlik: Yok",
            rules.rematchAllowed ? "Rövanş: Var" : "Rövanş: Yok",
            rules.doubleRound ? "Devre: Çift" : "Devre: Tek",
            "Format: \(rules.matchFormat.displayName)",
            "Puan: Galibiyet \(rules.pointsWin) · Beraberlik \(rules.pointsDraw) · Mağlubiyet \(rules.pointsLoss)"
        ]

        let playersSummary = draft.players.isEmpty
            ? "Yok"
            : "(\(draft.players.count)) " + draft.players.map(\.displayName).joined(separator: ", ")

        viewController?.displaySummary(viewModel: .init(
            name: draft.name,
            sport: draft.displaySport,
            type: draft.type.displayName,
            rulesSummary: rulesLines.joined(separator: "\n"),
            playersSummary: playersSummary
        ))
    }

    func presentCreate(response: TournamentReview.Create.Response) {
        switch response.result {
        case .success:
            viewController?.displayCreate(viewModel: .init(errorMessage: nil))
        case .failure(let error):
            viewController?.displayCreate(viewModel: .init(errorMessage: error.localizedDescription))
        }
    }
}
