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
            return makeMainTabBarController()
        }
        return makeAuthNavigationController()
    }

    private func makeAuthNavigationController() -> UINavigationController {
        let loginViewController = SceneFactory.makeLoginScene(onAuthenticated: { [weak self] in self?.showMain() })
        return UINavigationController(rootViewController: loginViewController)
    }

    private func makeMainTabBarController() -> MainTabBarController {
        MainTabBarController(onSignOut: { [weak self] in self?.showLogin() })
    }

    private func showMain() {
        window?.rootViewController = makeMainTabBarController()
    }

    private func showLogin() {
        window?.rootViewController = makeAuthNavigationController()
    }
}
