//
//  UIViewPreview.swift
//  Versus
//

#if DEBUG
import SwiftUI

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    private let makeView: () -> View

    init(_ makeView: @escaping () -> View) {
        self.makeView = makeView
    }

    func makeUIView(context: Context) -> View {
        makeView()
    }

    func updateUIView(_ uiView: View, context: Context) {}
}
#endif
