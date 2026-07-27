//
//  ProfileModels.swift
//  Versus
//

import Foundation

enum Profile {
    enum Load {
        struct Request {}

        struct Response {
            let result: Result<AppUser, Error>
        }

        struct ViewModel {
            let username: String
            let email: String
        }
    }

    enum UpdateUsername {
        struct Request {
            let username: String
        }

        struct Response {
            let result: Result<AppUser, Error>
        }

        struct ViewModel {
            let username: String?
            let errorMessage: String?
        }
    }
}
