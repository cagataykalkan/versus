//
//  SplashViewController.swift
//  Versus
//

import UIKit

protocol SplashDisplayLogic: AnyObject {
    func displayGreeting(viewModel: Splash.Greeting.ViewModel)
}

final class SplashViewController: BaseViewController, SplashDisplayLogic {
    var interactor: SplashBusinessLogic?
    var router: SplashRouter?

    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchGreeting(request: Splash.Greeting.Request())
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
    }

    override func setupUI() {
        titleLabel.font = Theme.Font.title
        titleLabel.textColor = Theme.Color.primaryText
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }

    override func setupConstraints() {
        titleLabel.centerInSuperview()
    }

    func displayGreeting(viewModel: Splash.Greeting.ViewModel) {
        titleLabel.text = viewModel.displayText
    }
}
