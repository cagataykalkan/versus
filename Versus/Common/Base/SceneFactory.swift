//
//  SceneFactory.swift
//  Versus
//

import UIKit

enum SceneFactory {

    static func makeLoginScene(onAuthenticated: @escaping () -> Void) -> LoginViewController {
        let viewController = LoginViewController()
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.onAuthenticated = onAuthenticated

        return viewController
    }

    static func makeSignUpScene(onAuthenticated: @escaping () -> Void) -> SignUpViewController {
        let viewController = SignUpViewController()
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.onAuthenticated = onAuthenticated

        return viewController
    }

    static func makeProfileScene(onSignOut: @escaping () -> Void) -> ProfileViewController {
        let viewController = ProfileViewController()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.onSignOut = onSignOut

        return viewController
    }
}
