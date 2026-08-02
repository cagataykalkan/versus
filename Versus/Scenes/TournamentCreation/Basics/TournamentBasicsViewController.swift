//
//  TournamentBasicsViewController.swift
//  Versus
//

import UIKit

protocol TournamentBasicsDisplayLogic: AnyObject {
    func displaySave(viewModel: TournamentBasics.Save.ViewModel)
}

final class TournamentBasicsViewController: BaseViewController, TournamentBasicsDisplayLogic {
    var interactor: TournamentBasicsBusinessLogic?
    var router: TournamentBasicsRouter?

    private let nameField = UITextField()
    private let sportPicker = UIPickerView()
    private let customSportField = UITextField()
    private let errorLabel = UILabel()
    private let nextButton = UIButton(type: .system)

    private var selectedSport: Sport = .football

    override func viewDidLoad() {
        super.viewDidLoad()
        sportPicker.dataSource = self
        sportPicker.delegate = self
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
        title = "Turnuva Bilgileri"
    }

    override func setupUI() {
        nameField.placeholder = "Turnuva Adı"
        nameField.borderStyle = .roundedRect

        customSportField.placeholder = "Özel Oyun Adı"
        customSportField.borderStyle = .roundedRect
        customSportField.isHidden = true

        errorLabel.textColor = .systemRed
        errorLabel.font = Theme.Font.body
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        nextButton.setTitle("İleri", for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        [nameField, sportPicker, customSportField, errorLabel, nextButton].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.Spacing.large),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            nameField.heightAnchor.constraint(equalToConstant: 44),

            sportPicker.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: Theme.Spacing.medium),
            sportPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sportPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sportPicker.heightAnchor.constraint(equalToConstant: 150),

            customSportField.topAnchor.constraint(equalTo: sportPicker.bottomAnchor, constant: Theme.Spacing.medium),
            customSportField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            customSportField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),
            customSportField.heightAnchor.constraint(equalToConstant: 44),

            errorLabel.topAnchor.constraint(equalTo: customSportField.bottomAnchor, constant: Theme.Spacing.small),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            nextButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Theme.Spacing.medium),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapNext() {
        interactor?.save(request: .init(
            name: nameField.text ?? "",
            sport: selectedSport,
            customSportName: customSportField.text ?? ""
        ))
    }

    func displaySave(viewModel: TournamentBasics.Save.ViewModel) {
        errorLabel.text = viewModel.errorMessage
        if viewModel.errorMessage == nil {
            router?.routeToTypeRules()
        }
    }
}

extension TournamentBasicsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Sport.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Sport.allCases[row].displayName
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSport = Sport.allCases[row]
        customSportField.isHidden = selectedSport != .custom
    }
}
