//
//  HomeRouter.swift
//  Versus
//

import UIKit

protocol HomeRoutingLogic {
    func routeToLogin()
}

final class HomeRouter: BaseRouter, HomeRoutingLogic {
    weak var viewController: HomeViewController?
    var onSignOut: (() -> Void)?

    func routeToLogin() {
        onSignOut?()
    }
}
