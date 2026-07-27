//
//  ProfileViewController.swift
//  Versus
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func displayProfile(viewModel: Profile.Load.ViewModel)
    func displayUpdateUsername(viewModel: Profile.UpdateUsername.ViewModel)
    func displaySignOut()
}

final class ProfileViewController: BaseViewController, ProfileDisplayLogic {
    var interactor: ProfileBusinessLogic?
    var router: ProfileRouter?

    private let avatarImageView = UIImageView()
    private let usernameField = UITextField()
    private let saveUsernameButton = UIButton(type: .system)
    private let emailLabel = UILabel()
    private let errorLabel = UILabel()
    private let statsPlaceholderLabel = UILabel()
    private let signOutButton = UIButton(type: .system)

    private var loadedUsername = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchProfile(request: .init())
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
    }

    override func setupUI() {
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = .secondaryLabel
        avatarImageView.contentMode = .scaleAspectFit

        usernameField.borderStyle = .roundedRect
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.addTarget(self, action: #selector(usernameFieldDidChange), for: .editingChanged)

        saveUsernameButton.setTitle("Kaydet", for: .normal)
        saveUsernameButton.addTarget(self, action: #selector(didTapSaveUsername), for: .touchUpInside)
        saveUsernameButton.isEnabled = false

        emailLabel.font = Theme.Font.body
        emailLabel.textColor = Theme.Color.secondaryText
        emailLabel.textAlignment = .center

        errorLabel.textColor = .systemRed
        errorLabel.font = Theme.Font.body
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        statsPlaceholderLabel.text = "İstatistikler yakında"
        statsPlaceholderLabel.font = Theme.Font.body
        statsPlaceholderLabel.textColor = Theme.Color.secondaryText
        statsPlaceholderLabel.textAlignment = .center

        signOutButton.setTitle("Çıkış Yap", for: .normal)
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)

        [avatarImageView, usernameField, saveUsernameButton, emailLabel, errorLabel, statsPlaceholderLabel, signOutButton].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.Spacing.large * 2),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 96),
            avatarImageView.heightAnchor.constraint(equalToConstant: 96),

            usernameField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Theme.Spacing.large),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            usernameField.heightAnchor.constraint(equalToConstant: 44),

            saveUsernameButton.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: Theme.Spacing.small),
            saveUsernameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: saveUsernameButton.bottomAnchor, constant: Theme.Spacing.medium),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            errorLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: Theme.Spacing.small),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            statsPlaceholderLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Theme.Spacing.large * 2),
            statsPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Theme.Spacing.large),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func usernameFieldDidChange() {
        let trimmed = (usernameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        saveUsernameButton.isEnabled = !trimmed.isEmpty && trimmed != loadedUsername
    }

    @objc private func didTapSaveUsername() {
        errorLabel.text = nil
        saveUsernameButton.isEnabled = false
        let trimmed = (usernameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        interactor?.updateUsername(request: .init(username: trimmed))
    }

    @objc private func didTapSignOut() {
        interactor?.signOut()
    }

    func displayProfile(viewModel: Profile.Load.ViewModel) {
        loadedUsername = viewModel.username
        usernameField.text = viewModel.username
        emailLabel.text = viewModel.email
    }

    func displayUpdateUsername(viewModel: Profile.UpdateUsername.ViewModel) {
        if let username = viewModel.username {
            loadedUsername = username
            usernameField.text = username
        }
        errorLabel.text = viewModel.errorMessage
        saveUsernameButton.isEnabled = false
    }

    func displaySignOut() {
        router?.routeToLogin()
    }
}
