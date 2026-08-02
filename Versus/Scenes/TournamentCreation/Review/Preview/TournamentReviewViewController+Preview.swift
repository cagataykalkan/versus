//
//  TournamentReviewViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Review") {
    UIViewControllerPreview {
        let draft = TournamentCreationDraft()
        draft.name = "Cuma Ligi"
        draft.sport = .eaFC
        draft.players = [
            DraftPlayer(id: "1", kind: .guest, displayName: "Ali"),
            DraftPlayer(id: "2", kind: .guest, displayName: "Mehmet"),
            DraftPlayer(id: "3", kind: .guest, displayName: "Ayşe")
        ]

        let viewController = TournamentReviewViewController()
        let interactor = TournamentReviewInteractor(draft: draft)
        let presenter = TournamentReviewPresenter()
        let router = TournamentReviewRouter()

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
