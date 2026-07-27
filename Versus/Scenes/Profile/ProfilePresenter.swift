//
//  ProfilePresenter.swift
//  Versus
//

import Foundation

protocol ProfilePresentationLogic {
    func presentProfile(response: Profile.Load.Response)
    func presentUpdateUsername(response: Profile.UpdateUsername.Response)
    func presentSignOut()
}

final class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: ProfileDisplayLogic?

    func presentProfile(response: Profile.Load.Response) {
        switch response.result {
        case .success(let user):
            viewController?.displayProfile(viewModel: .init(username: user.username, email: user.email))
        case .failure(let error):
            viewController?.displayProfile(viewModel: .init(username: "-", email: error.localizedDescription))
        }
    }

    func presentUpdateUsername(response: Profile.UpdateUsername.Response) {
        switch response.result {
        case .success(let user):
            viewController?.displayUpdateUsername(viewModel: .init(username: user.username, errorMessage: nil))
        case .failure(let error):
            viewController?.displayUpdateUsername(viewModel: .init(username: nil, errorMessage: error.localizedDescription))
        }
    }

    func presentSignOut() {
        viewController?.displaySignOut()
    }
}
