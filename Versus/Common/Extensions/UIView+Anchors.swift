//
//  UIView+Anchors.swift
//  Versus
//

import UIKit

extension UIView {

    func prepareForAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func pinEdges(to view: UIView, insets: UIEdgeInsets = .zero) {
        prepareForAutoLayout()
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func centerInSuperview() {
        guard let superview else { return }
        prepareForAutoLayout()
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
}
