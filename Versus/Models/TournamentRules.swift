//
//  TournamentRules.swift
//  Versus
//

import Foundation

enum MatchFormat: String, CaseIterable, Codable {
    case single
    case bo3
    case bo5

    var displayName: String {
        switch self {
        case .single: return "Tek Maç"
        case .bo3: return "BO3"
        case .bo5: return "BO5"
        }
    }
}

struct TournamentRules: Codable, Equatable {
    var drawAllowed: Bool
    var rematchAllowed: Bool
    var doubleRound: Bool
    var matchFormat: MatchFormat
    var pointsWin: Int
    var pointsDraw: Int
    var pointsLoss: Int

    static func defaultRules(for sport: Sport) -> TournamentRules {
        TournamentRules(
            drawAllowed: sport.defaultDrawAllowed,
            rematchAllowed: false,
            doubleRound: false,
            matchFormat: .single,
            pointsWin: 3,
            pointsDraw: 1,
            pointsLoss: 0
        )
    }
}
