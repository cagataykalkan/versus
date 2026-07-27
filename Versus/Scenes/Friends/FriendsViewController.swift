//
//  FriendsViewController.swift
//  Versus
//

import UIKit

protocol FriendsDisplayLogic: AnyObject {
    func displayLoad(viewModel: Friends.Load.ViewModel)
    func displaySearch(viewModel: Friends.Search.ViewModel)
    func displaySendRequest(viewModel: Friends.SendRequest.ViewModel)
    func displayAcceptRequest(viewModel: Friends.AcceptRequest.ViewModel)
}

final class FriendsViewController: BaseViewController, FriendsDisplayLogic {
    var interactor: FriendsBusinessLogic?
    var router: FriendsRouter?

    private let searchBar = UISearchBar()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var friends: [AppUser] = []
    private var pendingRequests: [AppUser] = []
    private var searchResults: [AppUser] = []
    private var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loadFriends(request: .init())
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
        title = "Arkadaşlar"
    }

    override func setupUI() {
        searchBar.placeholder = "Kullanıcı adı ara"
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        [searchBar, tableView].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func displayLoad(viewModel: Friends.Load.ViewModel) {
        friends = viewModel.friends
        pendingRequests = viewModel.pendingRequests
        tableView.reloadData()
    }

    func displaySearch(viewModel: Friends.Search.ViewModel) {
        searchResults = viewModel.results
        tableView.reloadData()
    }

    func displaySendRequest(viewModel: Friends.SendRequest.ViewModel) {
        presentAlert(message: viewModel.message)
    }

    func displayAcceptRequest(viewModel: Friends.AcceptRequest.ViewModel) {
        if let message = viewModel.message {
            presentAlert(message: message)
        }
    }

    private func presentAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        isSearching = !trimmed.isEmpty
        if isSearching {
            interactor?.search(request: .init(query: trimmed))
        } else {
            searchResults = []
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        searchResults = []
        tableView.reloadData()
    }
}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        isSearching ? 1 : 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return "Arama Sonuçları"
        }
        return section == 0 ? "Gelen İstekler" : "Arkadaşlar"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResults.count
        }
        return section == 0 ? pendingRequests.count : friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryView = nil

        if isSearching {
            let user = searchResults[indexPath.row]
            cell.textLabel?.text = user.username
            cell.accessoryView = makeActionButton(title: "Ekle", tag: indexPath.row, action: #selector(didTapAdd(_:)))
        } else if indexPath.section == 0 {
            let user = pendingRequests[indexPath.row]
            cell.textLabel?.text = user.username
            cell.accessoryView = makeActionButton(title: "Kabul Et", tag: indexPath.row, action: #selector(didTapAccept(_:)))
        } else {
            let user = friends[indexPath.row]
            cell.textLabel?.text = user.username
        }
        return cell
    }

    private func makeActionButton(title: String, tag: Int, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tag = tag
        button.addTarget(self, action: action, for: .touchUpInside)
        button.sizeToFit()
        return button
    }

    @objc private func didTapAdd(_ sender: UIButton) {
        let user = searchResults[sender.tag]
        interactor?.sendRequest(request: .init(userId: user.id))
    }

    @objc private func didTapAccept(_ sender: UIButton) {
        let user = pendingRequests[sender.tag]
        interactor?.acceptRequest(request: .init(userId: user.id))
    }
}
