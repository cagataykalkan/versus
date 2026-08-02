//
//  TournamentTypeRulesViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Type & Rules") {
    UIViewControllerPreview {
        UINavigationController(rootViewController: SceneFactory.makeTournamentTypeRulesScene(draft: TournamentCreationDraft()))
    }
}
#endif
