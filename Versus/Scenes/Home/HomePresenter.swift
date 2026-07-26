//
//  HomePresenter.swift
//  Versus
//

import Foundation

protocol HomePresentationLogic {
    func presentProfile(response: Home.Load.Response)
    func presentSignOut()
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?

    func presentProfile(response: Home.Load.Response) {
        switch response.result {
        case .success(let user):
            viewController?.displayProfile(viewModel: .init(welcomeText: "Hoş geldin, \(user.username)"))
        case .failure:
            viewController?.displayProfile(viewModel: .init(welcomeText: "Hoş geldin"))
        }
    }

    func presentSignOut() {
        viewController?.displaySignOut()
    }
}
