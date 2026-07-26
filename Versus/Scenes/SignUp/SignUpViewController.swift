//
//  SignUpViewController.swift
//  Versus
//

import UIKit

protocol SignUpDisplayLogic: AnyObject {
    func displayRegisterSuccess()
    func displayRegisterError(viewModel: SignUp.Register.ViewModel)
}

final class SignUpViewController: BaseViewController, SignUpDisplayLogic {
    var interactor: SignUpBusinessLogic?
    var router: SignUpRouter?

    private let titleLabel = UILabel()
    private let usernameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let confirmPasswordField = UITextField()
    private let errorLabel = UILabel()
    private let registerButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
    }

    override func setupUI() {
        titleLabel.text = "Kayıt Ol"
        titleLabel.font = Theme.Font.title
        titleLabel.textAlignment = .center

        usernameField.placeholder = "Kullanıcı Adı"
        usernameField.borderStyle = .roundedRect
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no

        emailField.placeholder = "E-posta"
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no

        passwordField.placeholder = "Şifre"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        confirmPasswordField.placeholder = "Şifre (Tekrar)"
        confirmPasswordField.borderStyle = .roundedRect
        confirmPasswordField.isSecureTextEntry = true

        errorLabel.textColor = .systemRed
        errorLabel.font = Theme.Font.body
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        registerButton.setTitle("Kayıt Ol", for: .normal)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)

        [titleLabel, usernameField, emailField, passwordField, confirmPasswordField, errorLabel, registerButton, activityIndicator].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.Spacing.large * 2),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            usernameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Theme.Spacing.large),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            usernameField.heightAnchor.constraint(equalToConstant: 44),

            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: Theme.Spacing.medium),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            emailField.heightAnchor.constraint(equalToConstant: 44),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: Theme.Spacing.medium),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: Theme.Spacing.medium),
            confirmPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            confirmPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 44),

            errorLabel.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: Theme.Spacing.small),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            registerButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Theme.Spacing.medium),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: Theme.Spacing.small)
        ])
    }

    @objc private func didTapRegister() {
        errorLabel.text = nil
        activityIndicator.startAnimating()
        registerButton.isEnabled = false
        interactor?.register(request: .init(
            username: usernameField.text ?? "",
            email: emailField.text ?? "",
            password: passwordField.text ?? "",
            confirmPassword: confirmPasswordField.text ?? ""
        ))
    }

    func displayRegisterSuccess() {
        activityIndicator.stopAnimating()
        registerButton.isEnabled = true
        router?.completeAuthentication()
    }

    func displayRegisterError(viewModel: SignUp.Register.ViewModel) {
        activityIndicator.stopAnimating()
        registerButton.isEnabled = true
        errorLabel.text = viewModel.errorMessage
    }
}
