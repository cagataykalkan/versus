//
//  Log.swift
//  Versus
//

import Foundation

enum Log {
    static func request(_ message: String) {
        print("➡️ [Versus] \(message)")
    }

    static func response(_ message: String) {
        print("⬅️ [Versus] \(message)")
    }
}
