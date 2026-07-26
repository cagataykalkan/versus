//
//  SplashViewController+Preview.swift
//  Versus
//

#if DEBUG
import SwiftUI

#Preview("Splash") {
    UIViewControllerPreview {
        SceneFactory.makeSplashScene()
    }
}
#endif
