//
//  APIAuthorizationMethod.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

/// Authorization method that request should be performed with
enum APIAuthorizationMethod {
    /// Bearer token
    case bearer
    /// No authorization
    case none
}
