//
//  TournamentType.swift
//  Versus
//

import Foundation

enum TournamentType: String, CaseIterable, Codable {
    case league
    case playoff
    case singleElimination
    case ranking

    var displayName: String {
        switch self {
        case .league: return "League"
        case .playoff: return "Playoff"
        case .singleElimination: return "Single Elimination"
        case .ranking: return "Ranking"
        }
    }

    /// Only League is supported in v1; the rest are shown but disabled.
    var isAvailable: Bool {
        self == .league
    }
}
