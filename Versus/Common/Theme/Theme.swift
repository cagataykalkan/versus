//
//  Theme.swift
//  Versus
//

import UIKit

enum Theme {

    enum Color {
        static let background = UIColor.systemBackground
        static let primaryText = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
    }

    enum Font {
        static let title = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
    }

    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
}
