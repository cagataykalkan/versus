//
//  ProfileRouter.swift
//  Versus
//

import UIKit

protocol ProfileRoutingLogic {
    func routeToLogin()
}

final class ProfileRouter: BaseRouter, ProfileRoutingLogic {
    weak var viewController: ProfileViewController?
    var onSignOut: (() -> Void)?

    func routeToLogin() {
        onSignOut?()
    }
}
