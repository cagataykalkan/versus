//
//  LoginViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

private func makeLoginPreviewScene(result: Result<AppUser, Error> = .success(
    AppUser(id: "preview", username: "player1", email: "player1@example.com", photoURL: nil)
)) -> LoginViewController {
    let viewController = LoginViewController()
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()

    let mockWorker = MockAuthWorker()
    mockWorker.result = result
    interactor.worker = mockWorker

    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController

    return viewController
}

#Preview("Login") {
    UIViewControllerPreview {
        makeLoginPreviewScene()
    }
}

#Preview("Login - Error") {
    UIViewControllerPreview {
        let viewController = makeLoginPreviewScene(result: .failure(WorkerError.underlying("Şifre hatalı.")))
        viewController.loadViewIfNeeded()
        viewController.displaySignInError(viewModel: .init(errorMessage: "Şifre hatalı."))
        return viewController
    }
}
#endif
