//
//  HomeInteractor.swift
//  Versus
//

import Foundation

protocol HomeBusinessLogic {
    func fetchProfile(request: Home.Load.Request)
    func signOut()
}

final class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    var worker: AuthWorkerProtocol = FirebaseAuthWorker()

    func fetchProfile(request: Home.Load.Request) {
        Task {
            do {
                let user = try await worker.fetchCurrentUser()
                presenter?.presentProfile(response: .init(result: .success(user)))
            } catch {
                presenter?.presentProfile(response: .init(result: .failure(error)))
            }
        }
    }

    func signOut() {
        try? worker.signOut()
        presenter?.presentSignOut()
    }
}
