//
//  LoginRouter.swift
//  Versus
//

import UIKit

protocol LoginRoutingLogic {
    func routeToSignUp()
    func completeAuthentication()
}

final class LoginRouter: BaseRouter, LoginRoutingLogic {
    weak var viewController: LoginViewController?
    var onAuthenticated: (() -> Void)?

    func routeToSignUp() {
        guard let viewController else { return }
        let signUpViewController = SceneFactory.makeSignUpScene(onAuthenticated: onAuthenticated ?? {})
        navigate(to: signUpViewController, from: viewController, style: .push)
    }

    func completeAuthentication() {
        onAuthenticated?()
    }
}
