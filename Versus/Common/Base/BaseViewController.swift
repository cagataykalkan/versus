//
//  BaseViewController.swift
//  Versus
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupUI()
        setupConstraints()
    }

    /// Colors, fonts and other appearance defaults. Runs before setupUI().
    func setupStyle() {}

    /// Subview creation and hierarchy (addSubview calls). Runs before setupConstraints().
    func setupUI() {}

    /// NSLayoutAnchor constraint activation.
    func setupConstraints() {}
}
