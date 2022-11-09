//
//  ExampleAPIRouter.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Alamofire
import Foundation

enum ExampleAPIRouter: APIRouter {
    case getExamples

    var path: String {
        switch self {
        case .getExamples: return "/getExamples"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getExamples: return .get
        }
    }

    var authorizationMethod: APIAuthorizationMethod {
        .bearer
    }

    func applyParameters(to request: inout URLRequest) throws {}
}
