//
//  HomeViewController.swift
//  Versus
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayProfile(viewModel: Home.Load.ViewModel)
    func displaySignOut()
}

final class HomeViewController: BaseViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: HomeRouter?

    private let welcomeLabel = UILabel()
    private let signOutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchProfile(request: .init())
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
    }

    override func setupUI() {
        welcomeLabel.font = Theme.Font.title
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0

        signOutButton.setTitle("Çıkış Yap", for: .normal)
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)

        [welcomeLabel, signOutButton].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        welcomeLabel.centerInSuperview()
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            signOutButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Theme.Spacing.large),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapSignOut() {
        interactor?.signOut()
    }

    func displayProfile(viewModel: Home.Load.ViewModel) {
        welcomeLabel.text = viewModel.welcomeText
    }

    func displaySignOut() {
        router?.routeToLogin()
    }
}
