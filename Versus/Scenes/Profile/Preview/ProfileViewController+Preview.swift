//
//  ProfileViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Profile") {
    UIViewControllerPreview {
        let viewController = ProfileViewController()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()

        interactor.worker = MockAuthWorker()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
#endif
