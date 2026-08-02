//
//  TournamentTypeRulesViewController.swift
//  Versus
//

import UIKit

protocol TournamentTypeRulesDisplayLogic: AnyObject {
    func displayDefaults(viewModel: TournamentTypeRules.Load.ViewModel)
    func displaySave(viewModel: TournamentTypeRules.Save.ViewModel)
}

final class TournamentTypeRulesViewController: BaseViewController, TournamentTypeRulesDisplayLogic {
    var interactor: TournamentTypeRulesBusinessLogic?
    var router: TournamentTypeRulesRouter?

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private var typeButtons: [TournamentType: UIButton] = [:]
    private var selectedType: TournamentType = .league

    private let drawSwitch = UISwitch()
    private let rematchSwitch = UISwitch()
    private let doubleRoundSwitch = UISwitch()
    private let matchFormatControl = UISegmentedControl(items: MatchFormat.allCases.map(\.displayName))

    private let winStepper = UIStepper()
    private let drawStepper = UIStepper()
    private let lossStepper = UIStepper()
    private let winValueLabel = UILabel()
    private let drawValueLabel = UILabel()
    private let lossValueLabel = UILabel()

    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loadDefaults(request: .init())
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
        title = "Tip ve Kurallar"
    }

    override func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = Theme.Spacing.medium

        stackView.addArrangedSubview(sectionLabel("Turnuva Tipi"))
        stackView.addArrangedSubview(makeTypeSelector())
        stackView.addArrangedSubview(sectionLabel("Kurallar"))
        stackView.addArrangedSubview(makeSwitchRow(title: "Beraberlik olabilir", control: drawSwitch))
        stackView.addArrangedSubview(makeSwitchRow(title: "Rövanş oynansın", control: rematchSwitch))
        stackView.addArrangedSubview(makeSwitchRow(title: "Çift devre (rövanşlı lig)", control: doubleRoundSwitch))
        stackView.addArrangedSubview(sectionLabel("Maç Formatı"))
        stackView.addArrangedSubview(matchFormatControl)
        stackView.addArrangedSubview(sectionLabel("Puanlama"))
        stackView.addArrangedSubview(makeStepperRow(title: "Galibiyet", stepper: winStepper, valueLabel: winValueLabel))
        stackView.addArrangedSubview(makeStepperRow(title: "Beraberlik", stepper: drawStepper, valueLabel: drawValueLabel))
        stackView.addArrangedSubview(makeStepperRow(title: "Mağlubiyet", stepper: lossStepper, valueLabel: lossValueLabel))

        nextButton.setTitle("İleri", for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        stackView.addArrangedSubview(nextButton)

        scrollView.prepareForAutoLayout()
        stackView.prepareForAutoLayout()
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Theme.Spacing.large),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Theme.Spacing.large),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Theme.Spacing.large),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Theme.Spacing.large),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -Theme.Spacing.large * 2)
        ])
    }

    private func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = Theme.Color.secondaryText
        return label
    }

    private func makeTypeSelector() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Theme.Spacing.small
        for (index, type) in TournamentType.allCases.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(type.isAvailable ? type.displayName : "\(type.displayName) (yakında)", for: .normal)
            button.contentHorizontalAlignment = .leading
            button.isEnabled = type.isAvailable
            button.tag = index
            button.addTarget(self, action: #selector(didSelectType(_:)), for: .touchUpInside)
            typeButtons[type] = button
            stack.addArrangedSubview(button)
        }
        return stack
    }

    private func makeSwitchRow(title: String, control: UISwitch) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = Theme.Font.body
        let row = UIStackView(arrangedSubviews: [label, control])
        row.axis = .horizontal
        row.distribution = .equalSpacing
        return row
    }

    private func makeStepperRow(title: String, stepper: UIStepper, valueLabel: UILabel) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = Theme.Font.body
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)
        valueLabel.font = Theme.Font.body
        valueLabel.textAlignment = .right
        let row = UIStackView(arrangedSubviews: [label, valueLabel, stepper])
        row.axis = .horizontal
        row.spacing = Theme.Spacing.small
        return row
    }

    private func updateTypeSelectionUI() {
        for (type, button) in typeButtons {
            let color: UIColor = type == selectedType ? .systemBlue : (type.isAvailable ? .label : .secondaryLabel)
            button.setTitleColor(color, for: .normal)
        }
    }

    @objc private func didSelectType(_ sender: UIButton) {
        guard sender.tag < TournamentType.allCases.count else { return }
        let type = TournamentType.allCases[sender.tag]
        guard type.isAvailable else { return }
        selectedType = type
        updateTypeSelectionUI()
    }

    @objc private func stepperChanged(_ sender: UIStepper) {
        let value = "\(Int(sender.value))"
        switch sender {
        case winStepper: winValueLabel.text = value
        case drawStepper: drawValueLabel.text = value
        case lossStepper: lossValueLabel.text = value
        default: break
        }
    }

    @objc private func didTapNext() {
        interactor?.save(request: .init(
            type: selectedType,
            drawAllowed: drawSwitch.isOn,
            rematchAllowed: rematchSwitch.isOn,
            doubleRound: doubleRoundSwitch.isOn,
            matchFormat: MatchFormat.allCases[matchFormatControl.selectedSegmentIndex],
            pointsWin: Int(winStepper.value),
            pointsDraw: Int(drawStepper.value),
            pointsLoss: Int(lossStepper.value)
        ))
    }

    func displayDefaults(viewModel: TournamentTypeRules.Load.ViewModel) {
        selectedType = viewModel.type
        updateTypeSelectionUI()

        drawSwitch.isOn = viewModel.drawAllowed
        rematchSwitch.isOn = viewModel.rematchAllowed
        doubleRoundSwitch.isOn = viewModel.doubleRound
        matchFormatControl.selectedSegmentIndex = MatchFormat.allCases.firstIndex(of: viewModel.matchFormat) ?? 0

        winStepper.value = Double(viewModel.pointsWin)
        drawStepper.value = Double(viewModel.pointsDraw)
        lossStepper.value = Double(viewModel.pointsLoss)
        winValueLabel.text = "\(viewModel.pointsWin)"
        drawValueLabel.text = "\(viewModel.pointsDraw)"
        lossValueLabel.text = "\(viewModel.pointsLoss)"
    }

    func displaySave(viewModel: TournamentTypeRules.Save.ViewModel) {
        router?.routeToPlayers()
    }
}
