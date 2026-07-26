//
//  LoginPresenter.swift
//  Versus
//

import Foundation

protocol LoginPresentationLogic {
    func presentSignIn(response: Login.SignIn.Response)
}

final class LoginPresenter: LoginPresentationLogic {
    weak var viewController: LoginDisplayLogic?

    func presentSignIn(response: Login.SignIn.Response) {
        switch response.result {
        case .success:
            viewController?.displaySignInSuccess()
        case .failure(let error):
            viewController?.displaySignInError(viewModel: .init(errorMessage: error.localizedDescription))
        }
    }
}
