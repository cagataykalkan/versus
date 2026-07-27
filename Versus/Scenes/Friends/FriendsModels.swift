//
//  FriendsModels.swift
//  Versus
//

import Foundation

enum Friends {
    enum Load {
        struct Request {}

        struct Response {
            let friends: Result<[AppUser], Error>
            let pendingRequests: Result<[AppUser], Error>
        }

        struct ViewModel {
            let friends: [AppUser]
            let pendingRequests: [AppUser]
        }
    }

    enum Search {
        struct Request {
            let query: String
        }

        struct Response {
            let result: Result<[AppUser], Error>
        }

        struct ViewModel {
            let results: [AppUser]
        }
    }

    enum SendRequest {
        struct Request {
            let userId: String
        }

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let message: String
        }
    }

    enum AcceptRequest {
        struct Request {
            let userId: String
        }

        struct Response {
            let result: Result<Void, Error>
        }

        struct ViewModel {
            let message: String?
        }
    }
}
