//
//  UIViewControllerPreview.swift
//  Versus
//

#if DEBUG
import SwiftUI

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    private let makeViewController: () -> ViewController

    init(_ makeViewController: @escaping () -> ViewController) {
        self.makeViewController = makeViewController
    }

    func makeUIViewController(context: Context) -> ViewController {
        makeViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}
#endif
