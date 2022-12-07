//
//  AppErrors.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Alamofire
import Foundation

// MARK: - AppError

struct AppError: LocalizedError {
    let message: String

    var errorDescription: String? {
        message
    }

    static var empty: AppError {
        .init(message: "")
    }
}
