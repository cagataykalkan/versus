//
//  SplashPresenter.swift
//  Versus
//

import Foundation

protocol SplashPresentationLogic {
    func presentGreeting(response: Splash.Greeting.Response)
}

final class SplashPresenter: SplashPresentationLogic {
    weak var viewController: SplashDisplayLogic?

    func presentGreeting(response: Splash.Greeting.Response) {
        let viewModel = Splash.Greeting.ViewModel(displayText: response.appName)
        viewController?.displayGreeting(viewModel: viewModel)
    }
}
