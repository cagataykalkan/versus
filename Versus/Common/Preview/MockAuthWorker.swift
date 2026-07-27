//
//  MockAuthWorker.swift
//  Versus
//

#if DEBUG
final class MockAuthWorker: AuthWorkerProtocol {
    var currentUserId: String?
    var result: Result<AppUser, Error> = .success(
        AppUser(id: "preview-user", username: "player1", email: "player1@example.com", photoURL: nil)
    )

    func signUp(email: String, password: String, username: String) async throws -> AppUser {
        try result.get()
    }

    func signIn(email: String, password: String) async throws -> AppUser {
        try result.get()
    }

    func fetchCurrentUser() async throws -> AppUser {
        try result.get()
    }

    func updateUsername(_ newUsername: String) async throws -> AppUser {
        try result.get()
    }

    func signOut() throws {}
}
#endif
