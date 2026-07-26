//
//  BaseRouter.swift
//  Versus
//

import UIKit

enum ScenePresentationStyle {
    case push
    case present(animated: Bool = true)
}

class BaseRouter: NSObject {

    func navigate(to destination: UIViewController, from source: UIViewController, style: ScenePresentationStyle) {
        switch style {
        case .push:
            source.navigationController?.pushViewController(destination, animated: true)
        case .present(let animated):
            source.present(destination, animated: animated)
        }
    }
}
