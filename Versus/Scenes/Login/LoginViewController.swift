//
//  LoginViewController.swift
//  Versus
//

import UIKit

protocol LoginDisplayLogic: AnyObject {
    func displaySignInSuccess()
    func displaySignInError(viewModel: Login.SignIn.ViewModel)
}

final class LoginViewController: BaseViewController, LoginDisplayLogic {
    var interactor: LoginBusinessLogic?
    var router: LoginRouter?

    private let titleLabel = UILabel()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let errorLabel = UILabel()
    private let signInButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let signUpButton = UIButton(type: .system)

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
    }

    override func setupUI() {
        titleLabel.text = "Versus Social"
        titleLabel.font = Theme.Font.title
        titleLabel.textAlignment = .center

        emailField.placeholder = "E-posta"
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no

        passwordField.placeholder = "Şifre"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        errorLabel.textColor = .systemRed
        errorLabel.font = Theme.Font.body
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        signInButton.setTitle("Giriş Yap", for: .normal)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        signUpButton.setTitle("Hesabın yok mu? Kayıt Ol", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)

        [titleLabel, emailField, passwordField, errorLabel, signInButton, activityIndicator, signUpButton].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.Spacing.large * 3),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Theme.Spacing.large * 2),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            emailField.heightAnchor.constraint(equalToConstant: 44),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: Theme.Spacing.medium),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            errorLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: Theme.Spacing.small),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            signInButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Theme.Spacing.medium),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: Theme.Spacing.small),

            signUpButton.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: Theme.Spacing.medium),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapSignIn() {
        errorLabel.text = nil
        activityIndicator.startAnimating()
        signInButton.isEnabled = false
        interactor?.signIn(request: .init(
            email: (emailField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
            password: passwordField.text ?? ""
        ))
    }

    @objc private func didTapSignUp() {
        router?.routeToSignUp()
    }

    func displaySignInSuccess() {
        activityIndicator.stopAnimating()
        signInButton.isEnabled = true
        router?.completeAuthentication()
    }

    func displaySignInError(viewModel: Login.SignIn.ViewModel) {
        activityIndicator.stopAnimating()
        signInButton.isEnabled = true
        errorLabel.text = viewModel.errorMessage
    }
}
