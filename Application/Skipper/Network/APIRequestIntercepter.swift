//
//  APIRequestIntercepter.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Alamofire
import Foundation

// API request intercepter to handle auth header, bad connection retries and token refresh logic.

class APIRequestIntercepter: RequestInterceptor {
    private var refreshCompletions: [(Bool) -> Void] = []
    private let retryLimit = 3

    var logoutCompletion: ((Error) -> Void)?

    private let tokensContainer: TokensContainer
    private let refreshTokenFailureHandler: () -> Void

    init(tokensContainer: TokensContainer, refreshTokenFailureHandler: @escaping () -> Void) {
        self.tokensContainer = tokensContainer
        self.refreshTokenFailureHandler = refreshTokenFailureHandler
    }

    func adapt(_ urlRequest: URLRequest,
               for _: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void)
    {
        var request = urlRequest
        request.headers.add(.accept("application/json"))
        guard let accessToken = tokensContainer.tokens?.accessToken else {
            completion(.success(request))
            return
        }
        request.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(request))
    }

    func retry(_ request: Request, for _: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // Handle the case with a bad connection.
        if (error as NSError).code == NSURLErrorNotConnectedToInternet {
            if request.retryCount > retryLimit {
                completion(.doNotRetry)
            } else {
                Log.console("Bad connection, retrying...")
                completion(.retryWithDelay(1.0))
            }
            return
        }

        // Handle token refresh.
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            return
        }

        if APIError.refreshTokenStatusCodes.contains(response.statusCode) {
            let apiError = APIError.custom("Refresh token expired")
            if request.retryCount > 1 {
                if error.asAFError?.isRequestRetryError == true {
                    completion(.doNotRetry)
                } else {
                    completion(.doNotRetryWithError(apiError))
                }
            } else {
                if error.asAFError?.isRequestRetryError == true {
                    completion(.doNotRetry)
                } else {
                    Log.console("Request new token.")
                    requestNewToken { [weak self] isSuccess in
                        if isSuccess {
                            completion(.retry)
                        } else {
                            self?.refreshTokenFailureHandler()
                            completion(.doNotRetryWithError(apiError))
                        }
                    }
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }

    private func requestNewToken(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
