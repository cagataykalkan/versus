//
//  TournamentReviewViewController.swift
//  Versus
//

import UIKit

protocol TournamentReviewDisplayLogic: AnyObject {
    func displaySummary(viewModel: TournamentReview.Load.ViewModel)
    func displayCreate(viewModel: TournamentReview.Create.ViewModel)
}

final class TournamentReviewViewController: BaseViewController, TournamentReviewDisplayLogic {
    var interactor: TournamentReviewBusinessLogic?
    var router: TournamentReviewRouter?

    private let nameLabel = UILabel()
    private let sportLabel = UILabel()
    private let typeLabel = UILabel()
    private let rulesLabel = UILabel()
    private let playersLabel = UILabel()
    private let summaryStack = UIStackView()
    private let errorLabel = UILabel()
    private let createButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loadSummary(request: .init())
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
        title = "Özet"
    }

    override func setupUI() {
        nameLabel.font = Theme.Font.title
        nameLabel.numberOfLines = 0
        [sportLabel, typeLabel, rulesLabel, playersLabel].forEach {
            $0.font = Theme.Font.body
            $0.numberOfLines = 0
        }

        summaryStack.axis = .vertical
        summaryStack.spacing = Theme.Spacing.medium
        [nameLabel, sportLabel, typeLabel, rulesLabel, playersLabel].forEach { summaryStack.addArrangedSubview($0) }

        errorLabel.textColor = .systemRed
        errorLabel.font = Theme.Font.body
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        createButton.setTitle("Turnuva Oluştur", for: .normal)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)

        [summaryStack, errorLabel, createButton, activityIndicator].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            summaryStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.Spacing.large),
            summaryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            summaryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            errorLabel.topAnchor.constraint(equalTo: summaryStack.bottomAnchor, constant: Theme.Spacing.large),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            createButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Theme.Spacing.medium),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: Theme.Spacing.small)
        ])
    }

    @objc private func didTapCreate() {
        errorLabel.text = nil
        activityIndicator.startAnimating()
        createButton.isEnabled = false
        interactor?.createTournament(request: .init())
    }

    func displaySummary(viewModel: TournamentReview.Load.ViewModel) {
        nameLabel.text = viewModel.name
        sportLabel.text = "Spor: \(viewModel.sport)"
        typeLabel.text = "Tip: \(viewModel.type)"
        rulesLabel.text = viewModel.rulesSummary
        playersLabel.text = "Oyuncular: \(viewModel.playersSummary)"
    }

    func displayCreate(viewModel: TournamentReview.Create.ViewModel) {
        activityIndicator.stopAnimating()
        createButton.isEnabled = true
        if let message = viewModel.errorMessage {
            errorLabel.text = message
        } else {
            router?.routeToTournamentList()
        }
    }
}
