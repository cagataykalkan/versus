//
//  SignUpInteractor.swift
//  Versus
//

import Foundation

protocol SignUpBusinessLogic {
    func register(request: SignUp.Register.Request)
}

final class SignUpInteractor: SignUpBusinessLogic {
    var presenter: SignUpPresentationLogic?
    var worker: AuthWorkerProtocol = FirebaseAuthWorker()

    func register(request: SignUp.Register.Request) {
        guard request.password == request.confirmPassword else {
            presenter?.presentRegister(response: .init(result: .failure(WorkerError.passwordMismatch)))
            return
        }

        Task {
            do {
                let user = try await worker.signUp(
                    email: request.email,
                    password: request.password,
                    username: request.username
                )
                presenter?.presentRegister(response: .init(result: .success(user)))
            } catch {
                presenter?.presentRegister(response: .init(result: .failure(error)))
            }
        }
    }
}
