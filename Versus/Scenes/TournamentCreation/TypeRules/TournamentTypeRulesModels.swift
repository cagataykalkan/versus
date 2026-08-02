//
//  TournamentTypeRulesModels.swift
//  Versus
//

import Foundation

enum TournamentTypeRules {
    enum Load {
        struct Request {}

        struct Response {
            let type: TournamentType
            let rules: TournamentRules
        }

        struct ViewModel {
            let type: TournamentType
            let drawAllowed: Bool
            let rematchAllowed: Bool
            let doubleRound: Bool
            let matchFormat: MatchFormat
            let pointsWin: Int
            let pointsDraw: Int
            let pointsLoss: Int
        }
    }

    enum Save {
        struct Request {
            let type: TournamentType
            let drawAllowed: Bool
            let rematchAllowed: Bool
            let doubleRound: Bool
            let matchFormat: MatchFormat
            let pointsWin: Int
            let pointsDraw: Int
            let pointsLoss: Int
        }

        struct Response {}

        struct ViewModel {}
    }
}
