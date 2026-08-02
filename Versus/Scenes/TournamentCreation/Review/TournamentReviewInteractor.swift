//
//  TournamentReviewInteractor.swift
//  Versus
//

import Foundation

protocol TournamentReviewBusinessLogic {
    func loadSummary(request: TournamentReview.Load.Request)
    func createTournament(request: TournamentReview.Create.Request)
}

final class TournamentReviewInteractor: TournamentReviewBusinessLogic {
    var presenter: TournamentReviewPresentationLogic?
    let draft: TournamentCreationDraft
    var worker: TournamentWorkerProtocol = FirebaseTournamentWorker()

    init(draft: TournamentCreationDraft) {
        self.draft = draft
    }

    func loadSummary(request: TournamentReview.Load.Request) {
        presenter?.presentSummary(draft: draft)
    }

    func createTournament(request: TournamentReview.Create.Request) {
        Task {
            do {
                _ = try await worker.createTournament(draft: draft)
                presenter?.presentCreate(response: .init(result: .success(())))
            } catch {
                presenter?.presentCreate(response: .init(result: .failure(error)))
            }
        }
    }
}
