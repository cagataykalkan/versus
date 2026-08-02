//
//  TournamentPlayersViewController.swift
//  Versus
//

import UIKit

protocol TournamentPlayersDisplayLogic: AnyObject {
    func displayLoad(viewModel: TournamentPlayers.Load.ViewModel)
    func displayContinue(viewModel: TournamentPlayers.Continue.ViewModel)
}

final class TournamentPlayersViewController: BaseViewController, TournamentPlayersDisplayLogic {
    var interactor: TournamentPlayersBusinessLogic?
    var router: TournamentPlayersRouter?

    private let ownerLabel = UILabel()
    private let ownerSwitch = UISwitch()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let guestField = UITextField()
    private let addGuestButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let nextButton = UIButton(type: .system)

    private var currentUser: AppUser?
    private var friends: [AppUser] = []
    private var selectedFriendIds: Set<String> = []
    private var guestPlayers: [DraftPlayer] = []

    private var selectedPlayers: [DraftPlayer] {
        var players: [DraftPlayer] = []
        if ownerSwitch.isOn, let currentUser {
            players.append(DraftPlayer(id: currentUser.id, kind: .registered(currentUser), displayName: currentUser.username))
        }
        for friend in friends where selectedFriendIds.contains(friend.id) {
            players.append(DraftPlayer(id: friend.id, kind: .registered(friend), displayName: friend.username))
        }
        players.append(contentsOf: guestPlayers)
        return players
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        interactor?.loadPlayers(request: .init())
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
        title = "Oyuncular"
    }

    override func setupUI() {
        ownerLabel.text = "Ben de oynayacağım"
        ownerLabel.font = Theme.Font.body

        errorLabel.textColor = .systemRed
        errorLabel.font = Theme.Font.body
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0

        guestField.placeholder = "Misafir Oyuncu Adı"
        guestField.borderStyle = .roundedRect

        addGuestButton.setTitle("Ekle", for: .normal)
        addGuestButton.addTarget(self, action: #selector(didTapAddGuest), for: .touchUpInside)

        nextButton.setTitle("İleri", for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        [ownerLabel, ownerSwitch, tableView, guestField, addGuestButton, errorLabel, nextButton].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            ownerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.Spacing.medium),
            ownerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),

            ownerSwitch.centerYAnchor.constraint(equalTo: ownerLabel.centerYAnchor),
            ownerSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            tableView.topAnchor.constraint(equalTo: ownerLabel.bottomAnchor, constant: Theme.Spacing.medium),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 280),

            guestField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Theme.Spacing.small),
            guestField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            guestField.trailingAnchor.constraint(equalTo: addGuestButton.leadingAnchor, constant: -Theme.Spacing.small),
            guestField.heightAnchor.constraint(equalToConstant: 44),

            addGuestButton.centerYAnchor.constraint(equalTo: guestField.centerYAnchor),
            addGuestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            errorLabel.topAnchor.constraint(equalTo: guestField.bottomAnchor, constant: Theme.Spacing.small),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large),

            nextButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: Theme.Spacing.medium),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapAddGuest() {
        let name = (guestField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        guestPlayers.append(DraftPlayer(id: UUID().uuidString, kind: .guest, displayName: name))
        guestField.text = ""
        tableView.reloadData()
    }

    @objc private func didTapNext() {
        errorLabel.text = nil
        interactor?.continueToReview(request: .init(players: selectedPlayers))
    }

    func displayLoad(viewModel: TournamentPlayers.Load.ViewModel) {
        currentUser = viewModel.currentUser
        friends = viewModel.friends
        tableView.reloadData()
    }

    func displayContinue(viewModel: TournamentPlayers.Continue.ViewModel) {
        if let message = viewModel.errorMessage {
            errorLabel.text = message
        } else {
            router?.routeToReview()
        }
    }
}

extension TournamentPlayersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Arkadaşlar" : "Misafir Oyuncular"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? friends.count : guestPlayers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0 {
            let friend = friends[indexPath.row]
            cell.textLabel?.text = friend.username
            cell.accessoryType = selectedFriendIds.contains(friend.id) ? .checkmark : .none
            cell.selectionStyle = .default
        } else {
            cell.textLabel?.text = guestPlayers[indexPath.row].displayName
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 0 else { return }
        let friend = friends[indexPath.row]
        if selectedFriendIds.contains(friend.id) {
            selectedFriendIds.remove(friend.id)
        } else {
            selectedFriendIds.insert(friend.id)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == 1
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, indexPath.section == 1 else { return }
        guestPlayers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
