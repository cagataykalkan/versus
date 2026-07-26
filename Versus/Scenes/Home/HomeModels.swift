//
//  HomeModels.swift
//  Versus
//

import Foundation

enum Home {
    enum Load {
        struct Request {}

        struct Response {
            let result: Result<AppUser, Error>
        }

        struct ViewModel {
            let welcomeText: String
        }
    }
}
