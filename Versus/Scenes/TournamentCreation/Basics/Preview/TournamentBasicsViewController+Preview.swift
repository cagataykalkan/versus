//
//  TournamentBasicsViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Tournament Basics") {
    UIViewControllerPreview {
        UINavigationController(rootViewController: SceneFactory.makeTournamentBasicsScene())
    }
}
#endif
