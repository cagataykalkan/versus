//
//  TournamentBasicsInteractor.swift
//  Versus
//

import Foundation

protocol TournamentBasicsBusinessLogic {
    func save(request: TournamentBasics.Save.Request)
}

final class TournamentBasicsInteractor: TournamentBasicsBusinessLogic {
    var presenter: TournamentBasicsPresentationLogic?
    let draft: TournamentCreationDraft

    init(draft: TournamentCreationDraft) {
        self.draft = draft
    }

    func save(request: TournamentBasics.Save.Request) {
        let trimmedName = request.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            presenter?.presentSave(response: .init(errorMessage: "Turnuva adı boş olamaz."))
            return
        }

        var customSportName = ""
        if request.sport == .custom {
            customSportName = request.customSportName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !customSportName.isEmpty else {
                presenter?.presentSave(response: .init(errorMessage: "Özel oyun adı boş olamaz."))
                return
            }
        }

        draft.name = trimmedName
        draft.sport = request.sport
        draft.customSportName = customSportName
        draft.rules = .defaultRules(for: request.sport)

        presenter?.presentSave(response: .init(errorMessage: nil))
    }
}
