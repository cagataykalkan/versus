//
//  MockTournamentWorker.swift
//  Versus
//

#if DEBUG
import Foundation

final class MockTournamentWorker: TournamentWorkerProtocol {
    var tournaments: [Tournament] = [
        Tournament(
            id: "preview-1",
            ownerId: "preview-user",
            name: "Cuma Ligi",
            sport: .eaFC,
            customSportName: nil,
            type: .league,
            status: .active,
            rules: .defaultRules(for: .eaFC),
            players: [
                TournamentPlayer(id: "1", kind: .registered, displayName: "ali"),
                TournamentPlayer(id: "2", kind: .guest, displayName: "Misafir Oyuncu")
            ],
            createdAt: Date()
        )
    ]
    var createdTournamentId = "preview-created"

    func createTournament(draft: TournamentCreationDraft) async throws -> String { createdTournamentId }
    func fetchTournaments() async throws -> [Tournament] { tournaments }
}
#endif
