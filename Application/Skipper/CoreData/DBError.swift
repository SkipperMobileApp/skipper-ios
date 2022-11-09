//
//  DBError.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation

/// A custom error types related to database
enum DBError: LocalizedError {
    /// Error while creating an object
    case createNewObject(String)

    var errorDescription: String? {
        switch self {
        case let .createNewObject(message): return message
        }
    }
}
