//
//  Environment.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

enum Environment: String {
    case development, production

    static var current: Environment = .development

    var baseURL: String {
        switch self {
        case .development: return "https://dev.example.com"
        case .production: return "https://example.com"
        }
    }

    static func configureEnvironment() {
        guard let environmentString = Bundle.main.infoDictionary?["Environment"] as? String,
              let environment = Environment(rawValue: environmentString)
        else {
            Self.current = .development
            return
        }

        Self.current = environment
    }
}
