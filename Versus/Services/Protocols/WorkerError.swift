//
//  WorkerError.swift
//  Versus
//

import Foundation

enum WorkerError: LocalizedError {
    case usernameTaken
    case passwordMismatch
    case notAuthenticated
    case underlying(String)

    var errorDescription: String? {
        switch self {
        case .usernameTaken:
            return "Bu kullanıcı adı zaten alınmış."
        case .passwordMismatch:
            return "Şifreler eşleşmiyor."
        case .notAuthenticated:
            return "Oturum bulunamadı."
        case .underlying(let message):
            return message
        }
    }
}
