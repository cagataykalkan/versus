//
//  SplashRouter.swift
//  Versus
//

import UIKit

protocol SplashRoutingLogic {}

final class SplashRouter: BaseRouter, SplashRoutingLogic {
    weak var viewController: SplashViewController?
}
