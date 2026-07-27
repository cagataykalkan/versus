//
//  MainTabBarController.swift
//  Versus
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let onSignOut: () -> Void

    init(onSignOut: @escaping () -> Void) {
        self.onSignOut = onSignOut
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileViewController = SceneFactory.makeProfileScene(onSignOut: onSignOut)
        profileViewController.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.circle"), tag: 0)

        let friendsViewController = SceneFactory.makeFriendsScene()
        friendsViewController.tabBarItem = UITabBarItem(title: "Arkadaşlar", image: UIImage(systemName: "person.2"), tag: 1)

        viewControllers = [
            UINavigationController(rootViewController: profileViewController),
            UINavigationController(rootViewController: friendsViewController)
        ]
    }
}
