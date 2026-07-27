//
//  AppRouter.swift
//  Versus
//

import UIKit

final class AppRouter {
    private weak var window: UIWindow?
    private let authWorker: AuthWorkerProtocol = FirebaseAuthWorker()

    func start(in window: UIWindow) {
        self.window = window
        window.rootViewController = makeRootViewController()
        window.makeKeyAndVisible()
    }

    private func makeRootViewController() -> UIViewController {
        if authWorker.currentUserId != nil {
            return SceneFactory.makeProfileScene(onSignOut: { [weak self] in self?.showLogin() })
        }
        return makeAuthNavigationController()
    }

    private func makeAuthNavigationController() -> UINavigationController {
        let loginViewController = SceneFactory.makeLoginScene(onAuthenticated: { [weak self] in self?.showProfile() })
        return UINavigationController(rootViewController: loginViewController)
    }

    private func showProfile() {
        window?.rootViewController = SceneFactory.makeProfileScene(onSignOut: { [weak self] in self?.showLogin() })
    }

    private func showLogin() {
        window?.rootViewController = makeAuthNavigationController()
    }
}
