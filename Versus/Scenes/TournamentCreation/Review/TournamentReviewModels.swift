//
//  TournamentReviewModels.swift
//  Versus
//

import Foundation

enum TournamentReview {
    enum Load {
        struct Request {}

        struct ViewModel {
            let name: String
            let sport: String
            let type: String
            let rulesSummary: String
            let playersSummary: String
        }
    }

    enum Create {
        struct Request {}

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let errorMessage: String?
        }
    }
}
