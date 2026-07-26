//
//  SplashInteractor.swift
//  Versus
//

import Foundation

protocol SplashBusinessLogic {
    func fetchGreeting(request: Splash.Greeting.Request)
}

final class SplashInteractor: SplashBusinessLogic {
    var presenter: SplashPresentationLogic?

    func fetchGreeting(request: Splash.Greeting.Request) {
        let response = Splash.Greeting.Response(appName: "Versus Social")
        presenter?.presentGreeting(response: response)
    }
}
