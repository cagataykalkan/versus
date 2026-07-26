//
//  HomeViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Home") {
    UIViewControllerPreview {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()

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
