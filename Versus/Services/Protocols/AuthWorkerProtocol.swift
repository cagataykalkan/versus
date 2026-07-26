//
//  AuthWorkerProtocol.swift
//  Versus
//

import Foundation

protocol AuthWorkerProtocol {
    var currentUserId: String? { get }

    func signUp(email: String, password: String, username: String) async throws -> AppUser
    func signIn(email: String, password: String) async throws -> AppUser
    func fetchCurrentUser() async throws -> AppUser
    func signOut() throws
}
