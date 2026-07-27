//
//  FriendsRouter.swift
//  Versus
//

import UIKit

protocol FriendsRoutingLogic {}

final class FriendsRouter: BaseRouter, FriendsRoutingLogic {
    weak var viewController: FriendsViewController?
}
