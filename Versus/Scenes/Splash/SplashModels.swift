//
//  SplashModels.swift
//  Versus
//

import Foundation

enum Splash {
    enum Greeting {
        struct Request {}

        struct Response {
            let appName: String
        }

        struct ViewModel {
            let displayText: String
        }
    }
}
