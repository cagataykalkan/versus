//
//  TournamentWorkerProtocol.swift
//  Versus
//

import Foundation

protocol TournamentWorkerProtocol {
    func createTournament(draft: TournamentCreationDraft) async throws -> String
    func fetchTournaments() async throws -> [Tournament]
}
