//
//  SignUpRouter.swift
//  Versus
//

import UIKit

protocol SignUpRoutingLogic {
    func completeAuthentication()
}

final class SignUpRouter: BaseRouter, SignUpRoutingLogic {
    weak var viewController: SignUpViewController?
    var onAuthenticated: (() -> Void)?

    func completeAuthentication() {
        onAuthenticated?()
    }
}
