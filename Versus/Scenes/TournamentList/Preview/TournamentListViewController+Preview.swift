//
//  TournamentListViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Tournament List") {
    UIViewControllerPreview {
        let viewController = TournamentListViewController()
        let interactor = TournamentListInteractor()
        let presenter = TournamentListPresenter()
        let router = TournamentListRouter()

        interactor.worker = MockTournamentWorker()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return UINavigationController(rootViewController: viewController)
    }
}
#endif
