//
//  SceneFactory.swift
//  Versus
//

import UIKit

enum SceneFactory {

    static func makeSplashScene() -> SplashViewController {
        let viewController = SplashViewController()
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        let router = SplashRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
