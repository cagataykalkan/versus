//
//  TournamentListPresenter.swift
//  Versus
//

import Foundation

protocol TournamentListPresentationLogic {
    func presentLoad(response: TournamentList.Load.Response)
}

final class TournamentListPresenter: TournamentListPresentationLogic {
    weak var viewController: TournamentListDisplayLogic?

    func presentLoad(response: TournamentList.Load.Response) {
        switch response.result {
        case .success(let tournaments):
            viewController?.displayLoad(viewModel: .init(tournaments: tournaments, errorMessage: nil))
        case .failure(let error):
            viewController?.displayLoad(viewModel: .init(tournaments: [], errorMessage: error.localizedDescription))
        }
    }
}
