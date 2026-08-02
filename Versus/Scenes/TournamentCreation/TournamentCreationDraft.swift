//
//  TournamentCreationDraft.swift
//  Versus
//

import Foundation

struct DraftPlayer: Identifiable, Equatable {
    enum Kind: Equatable {
        case registered(AppUser)
        case guest
    }

    let id: String
    let kind: Kind
    var displayName: String
}

/// Shared, mutable, in-memory state for the tournament-creation wizard.
/// Passed by reference from step to step (Basics → TypeRules → Players → Review).
final class TournamentCreationDraft {
    var name: String = ""
    var sport: Sport = .football
    var customSportName: String = ""
    var type: TournamentType = .league
    var rules: TournamentRules = .defaultRules(for: .football)
    var players: [DraftPlayer] = []

    var displaySport: String {
        sport == .custom ? (customSportName.isEmpty ? "Custom Game" : customSportName) : sport.displayName
    }
}
