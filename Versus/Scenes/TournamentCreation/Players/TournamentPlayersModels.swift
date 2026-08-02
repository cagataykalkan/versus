//
//  TournamentPlayersModels.swift
//  Versus
//

import Foundation

enum TournamentPlayers {
    enum Load {
        struct Request {}

        struct Response {
            let currentUser: Result<AppUser, Error>
            let friends: Result<[AppUser], Error>
        }

        struct ViewModel {
            let currentUser: AppUser?
            let friends: [AppUser]
        }
    }

    enum Continue {
        struct Request {
            let players: [DraftPlayer]
        }

        struct Response {
            let errorMessage: String?
        }

        struct ViewModel {
            let errorMessage: String?
        }
    }
}
