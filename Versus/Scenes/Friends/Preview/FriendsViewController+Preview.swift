//
//  FriendsViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Friends") {
    UIViewControllerPreview {
        let viewController = FriendsViewController()
        let interactor = FriendsInteractor()
        let presenter = FriendsPresenter()
        let router = FriendsRouter()

        interactor.worker = MockFriendWorker()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
#endif
