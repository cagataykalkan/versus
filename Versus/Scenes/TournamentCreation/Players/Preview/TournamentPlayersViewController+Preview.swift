//
//  TournamentPlayersViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Players") {
    UIViewControllerPreview {
        let draft = TournamentCreationDraft()
        let viewController = TournamentPlayersViewController()
        let interactor = TournamentPlayersInteractor(draft: draft)
        let presenter = TournamentPlayersPresenter()
        let router = TournamentPlayersRouter()

        interactor.authWorker = MockAuthWorker()
        interactor.friendWorker = MockFriendWorker()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.draft = draft

        return UINavigationController(rootViewController: viewController)
    }
}
#endif
