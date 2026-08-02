//
//  TournamentListInteractor.swift
//  Versus
//

import Foundation

protocol TournamentListBusinessLogic {
    func loadTournaments(request: TournamentList.Load.Request)
}

final class TournamentListInteractor: TournamentListBusinessLogic {
    var presenter: TournamentListPresentationLogic?
    var worker: TournamentWorkerProtocol = FirebaseTournamentWorker()

    func loadTournaments(request: TournamentList.Load.Request) {
        Task {
            do {
                let tournaments = try await worker.fetchTournaments()
                presenter?.presentLoad(response: .init(result: .success(tournaments)))
            } catch {
                presenter?.presentLoad(response: .init(result: .failure(error)))
            }
        }
    }
}
