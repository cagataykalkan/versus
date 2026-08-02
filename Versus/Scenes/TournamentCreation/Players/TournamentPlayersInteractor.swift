//
//  TournamentPlayersInteractor.swift
//  Versus
//

import Foundation

protocol TournamentPlayersBusinessLogic {
    func loadPlayers(request: TournamentPlayers.Load.Request)
    func continueToReview(request: TournamentPlayers.Continue.Request)
}

final class TournamentPlayersInteractor: TournamentPlayersBusinessLogic {
    var presenter: TournamentPlayersPresentationLogic?
    let draft: TournamentCreationDraft
    var authWorker: AuthWorkerProtocol = FirebaseAuthWorker()
    var friendWorker: FriendWorkerProtocol = FirebaseFriendWorker()

    init(draft: TournamentCreationDraft) {
        self.draft = draft
    }

    func loadPlayers(request: TournamentPlayers.Load.Request) {
        Task {
            async let currentUserResult = result { try await self.authWorker.fetchCurrentUser() }
            async let friendsResult = result { try await self.friendWorker.fetchFriends() }
            let response = await TournamentPlayers.Load.Response(currentUser: currentUserResult, friends: friendsResult)
            presenter?.presentLoad(response: response)
        }
    }

    func continueToReview(request: TournamentPlayers.Continue.Request) {
        guard request.players.count >= 3 else {
            presenter?.presentContinue(response: .init(errorMessage: "En az 3 oyuncu gerekiyor (şu an \(request.players.count))."))
            return
        }
        draft.players = request.players
        presenter?.presentContinue(response: .init(errorMessage: nil))
    }

    private func result<T>(_ operation: () async throws -> T) async -> Result<T, Error> {
        do {
            return .success(try await operation())
        } catch {
            return .failure(error)
        }
    }
}
