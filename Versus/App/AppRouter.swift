//
//  AppRouter.swift
//  Versus
//

import UIKit

final class AppRouter {

    func start(in window: UIWindow) {
        window.rootViewController = SceneFactory.makeSplashScene()
        window.makeKeyAndVisible()
    }
}
