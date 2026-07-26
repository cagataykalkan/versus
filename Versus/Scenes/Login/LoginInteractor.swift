//
//  LoginInteractor.swift
//  Versus
//

import Foundation

protocol LoginBusinessLogic {
    func signIn(request: Login.SignIn.Request)
}

final class LoginInteractor: LoginBusinessLogic {
    var presenter: LoginPresentationLogic?
    var worker: AuthWorkerProtocol = FirebaseAuthWorker()

    func signIn(request: Login.SignIn.Request) {
        Task {
            do {
                let user = try await worker.signIn(email: request.email, password: request.password)
                presenter?.presentSignIn(response: .init(result: .success(user)))
            } catch {
                presenter?.presentSignIn(response: .init(result: .failure(error)))
            }
        }
    }
}
