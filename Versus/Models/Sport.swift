//
//  Sport.swift
//  Versus
//

import Foundation

enum Sport: String, CaseIterable, Codable {
    case football
    case basketball
    case eaFC
    case nba2K
    case backgammon
    case chess
    case billiards
    case tableTennis
    case custom

    var displayName: String {
        switch self {
        case .football: return "Football"
        case .basketball: return "Basketball"
        case .eaFC: return "EA FC"
        case .nba2K: return "NBA2K"
        case .backgammon: return "Backgammon"
        case .chess: return "Chess"
        case .billiards: return "Billiards"
        case .tableTennis: return "Table Tennis"
        case .custom: return "Custom Game"
        }
    }

    var defaultDrawAllowed: Bool {
        switch self {
        case .football, .eaFC, .chess, .backgammon, .custom: return true
        case .basketball, .nba2K, .billiards, .tableTennis: return false
        }
    }
}
