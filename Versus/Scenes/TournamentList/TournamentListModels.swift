//
//  TournamentListModels.swift
//  Versus
//

import Foundation

enum TournamentList {
    enum Load {
        struct Request {}

        struct Response {
            let result: Result<[Tournament], Error>
        }

        struct ViewModel {
            let tournaments: [Tournament]
            let errorMessage: String?
        }
    }
}
