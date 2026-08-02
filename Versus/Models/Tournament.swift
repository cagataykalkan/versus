//
//  Tournament.swift
//  Versus
//

import Foundation

enum PlayerKind: String, Codable {
    case registered
    case guest
}

struct TournamentPlayer: Identifiable, Equatable {
    let id: String
    let kind: PlayerKind
    var displayName: String
}

enum TournamentStatus: String, Codable {
    case active
    case completed
}

struct Tournament: Identifiable {
    let id: String
    let ownerId: String
    let name: String
    let sport: Sport
    let customSportName: String?
    let type: TournamentType
    let status: TournamentStatus
    let rules: TournamentRules
    let players: [TournamentPlayer]
    let createdAt: Date

    var displaySport: String {
        sport == .custom ? (customSportName ?? sport.displayName) : sport.displayName
    }
}
