//
//  TournamentBasicsModels.swift
//  Versus
//

import Foundation

enum TournamentBasics {
    enum Save {
        struct Request {
            let name: String
            let sport: Sport
            let customSportName: String
        }

        struct Response {
            let errorMessage: String?
        }

        struct ViewModel {
            let errorMessage: String?
        }
    }
}
