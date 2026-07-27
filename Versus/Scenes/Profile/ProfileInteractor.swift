//
//  ProfileInteractor.swift
//  Versus
//

import Foundation

protocol ProfileBusinessLogic {
    func fetchProfile(request: Profile.Load.Request)
    func updateUsername(request: Profile.UpdateUsername.Request)
    func signOut()
}

final class ProfileInteractor: ProfileBusinessLogic {
    var presenter: ProfilePresentationLogic?
    var worker: AuthWorkerProtocol = FirebaseAuthWorker()

    func fetchProfile(request: Profile.Load.Request) {
        Task {
            do {
                let user = try await worker.fetchCurrentUser()
                presenter?.presentProfile(response: .init(result: .success(user)))
            } catch {
                presenter?.presentProfile(response: .init(result: .failure(error)))
            }
        }
    }

    func updateUsername(request: Profile.UpdateUsername.Request) {
        Task {
            do {
                let user = try await worker.updateUsername(request.username)
                presenter?.presentUpdateUsername(response: .init(result: .success(user)))
            } catch {
                presenter?.presentUpdateUsername(response: .init(result: .failure(error)))
            }
        }
    }

    func signOut() {
        try? worker.signOut()
        presenter?.presentSignOut()
    }
}
