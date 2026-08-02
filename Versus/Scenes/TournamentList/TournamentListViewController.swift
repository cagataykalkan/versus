//
//  TournamentListViewController.swift
//  Versus
//

import UIKit

protocol TournamentListDisplayLogic: AnyObject {
    func displayLoad(viewModel: TournamentList.Load.ViewModel)
}

final class TournamentListViewController: BaseViewController, TournamentListDisplayLogic {
    var interactor: TournamentListBusinessLogic?
    var router: TournamentListRouter?

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyLabel = UILabel()

    private var tournaments: [Tournament] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.loadTournaments(request: .init())
    }

    override func setupStyle() {
        view.backgroundColor = Theme.Color.background
        title = "Turnuvalar"
    }

    override func setupUI() {
        emptyLabel.text = "Henüz turnuvan yok"
        emptyLabel.font = Theme.Font.body
        emptyLabel.textColor = Theme.Color.secondaryText
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true

        [tableView, emptyLabel].forEach {
            $0.prepareForAutoLayout()
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        tableView.pinEdges(to: view)
        emptyLabel.centerInSuperview()
    }

    @objc private func didTapAdd() {
        router?.routeToCreateTournament()
    }

    func displayLoad(viewModel: TournamentList.Load.ViewModel) {
        tournaments = viewModel.tournaments
        emptyLabel.isHidden = !tournaments.isEmpty
        tableView.reloadData()
    }
}

extension TournamentListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tournaments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let tournament = tournaments[indexPath.row]
        cell.textLabel?.text = tournament.name
        cell.detailTextLabel?.text = "\(tournament.displaySport) · \(tournament.type.displayName)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
