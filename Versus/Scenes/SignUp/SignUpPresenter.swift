//
//  SignUpPresenter.swift
//  Versus
//

import Foundation

protocol SignUpPresentationLogic {
    func presentRegister(response: SignUp.Register.Response)
}

final class SignUpPresenter: SignUpPresentationLogic {
    weak var viewController: SignUpDisplayLogic?

    func presentRegister(response: SignUp.Register.Response) {
        switch response.result {
        case .success:
            viewController?.displayRegisterSuccess()
        case .failure(let error):
            viewController?.displayRegisterError(viewModel: .init(errorMessage: error.localizedDescription))
        }
    }
}
