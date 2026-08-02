//
//  SceneFactory.swift
//  Versus
//

import UIKit

enum SceneFactory {

    static func makeLoginScene(onAuthenticated: @escaping () -> Void) -> LoginViewController {
        let viewController = LoginViewController()
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.onAuthenticated = onAuthenticated

        return viewController
    }

    static func makeSignUpScene(onAuthenticated: @escaping () -> Void) -> SignUpViewController {
        let viewController = SignUpViewController()
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.onAuthenticated = onAuthenticated

        return viewController
    }

    static func makeProfileScene(onSignOut: @escaping () -> Void) -> ProfileViewController {
        let viewController = ProfileViewController()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.onSignOut = onSignOut

        return viewController
    }

    static func makeFriendsScene() -> FriendsViewController {
        let viewController = FriendsViewController()
        let interactor = FriendsInteractor()
        let presenter = FriendsPresenter()
        let router = FriendsRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }

    static func makeTournamentListScene() -> TournamentListViewController {
        let viewController = TournamentListViewController()
        let interactor = TournamentListInteractor()
        let presenter = TournamentListPresenter()
        let router = TournamentListRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }

    static func makeTournamentBasicsScene() -> TournamentBasicsViewController {
        let draft = TournamentCreationDraft()
        let viewController = TournamentBasicsViewController()
        let interactor = TournamentBasicsInteractor(draft: draft)
        let presenter = TournamentBasicsPresenter()
        let router = TournamentBasicsRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.draft = draft

        return viewController
    }

    static func makeTournamentTypeRulesScene(draft: TournamentCreationDraft) -> TournamentTypeRulesViewController {
        let viewController = TournamentTypeRulesViewController()
        let interactor = TournamentTypeRulesInteractor(draft: draft)
        let presenter = TournamentTypeRulesPresenter()
        let router = TournamentTypeRulesRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.draft = draft

        return viewController
    }

    static func makeTournamentPlayersScene(draft: TournamentCreationDraft) -> TournamentPlayersViewController {
        let viewController = TournamentPlayersViewController()
        let interactor = TournamentPlayersInteractor(draft: draft)
        let presenter = TournamentPlayersPresenter()
        let router = TournamentPlayersRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.draft = draft

        return viewController
    }

    static func makeTournamentReviewScene(draft: TournamentCreationDraft) -> TournamentReviewViewController {
        let viewController = TournamentReviewViewController()
        let interactor = TournamentReviewInteractor(draft: draft)
        let presenter = TournamentReviewPresenter()
        let router = TournamentReviewRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
