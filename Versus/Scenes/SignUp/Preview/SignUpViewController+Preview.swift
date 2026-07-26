//
//  SignUpViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("SignUp") {
    UIViewControllerPreview {
        let viewController = SignUpViewController()
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()

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
