//
//  LoginModels.swift
//  Versus
//

import Foundation

enum Login {
    enum SignIn {
        struct Request {
            let email: String
            let password: String
        }

        struct Response {
            let result: Result<AppUser, Error>
        }

        struct ViewModel {
            let errorMessage: String?
        }
    }
}
