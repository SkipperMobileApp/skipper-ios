//
//  APIRouter.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Alamofire
import Foundation

/// More formalized `URLRequestConvertible` extension to use in enum-based API routers
protocol APIRouter: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var authorizationMethod: APIAuthorizationMethod { get }

    /// Concrete implementation of an API router should prepare parameters and
    /// reassign `request` variable by using `API.urlParameterEncoder` or `API.jsonParameterEncoder`.
    /// No need for implementing `asURLRequest` in concrete router.
    func applyParameters(to request: inout URLRequest) throws
}

extension APIRouter {
    var headers: HTTPHeaders? {
        return ["Accept": "application/json"]
    }

    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.method = method
        if let headers = headers {
            request.headers = headers
        }

        try applyParameters(to: &request)
        return request
    }

    var baseURL: URL {
        return URL(string: Environment.current.baseURL)!
    }

    func applyParameters(to _: inout URLRequest) throws {}
}
