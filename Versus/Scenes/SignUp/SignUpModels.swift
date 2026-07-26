//
//  SignUpModels.swift
//  Versus
//

import Foundation

enum SignUp {
    enum Register {
        struct Request {
            let username: String
            let email: String
            let password: String
            let confirmPassword: String
        }

        struct Response {
            let result: Result<AppUser, Error>
        }

        struct ViewModel {
            let errorMessage: String?
        }
    }
}
