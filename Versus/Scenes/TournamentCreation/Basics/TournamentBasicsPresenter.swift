//
//  TournamentBasicsPresenter.swift
//  Versus
//

import Foundation

protocol TournamentBasicsPresentationLogic {
    func presentSave(response: TournamentBasics.Save.Response)
}

final class TournamentBasicsPresenter: TournamentBasicsPresentationLogic {
    weak var viewController: TournamentBasicsDisplayLogic?

    func presentSave(response: TournamentBasics.Save.Response) {
        viewController?.displaySave(viewModel: .init(errorMessage: response.errorMessage))
    }
}
