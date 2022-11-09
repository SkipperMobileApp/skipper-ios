import Alamofire
import Combine
import Foundation

struct EmptyResponse: Codable {}

/// The class provides convenient access to API endpoints.
class API {
    private let interceptor: RequestInterceptor
    private let session: Session
    private let reachability: NetworkReachability

    var logoutFailure: ((Error) -> Void)?

    init(interceptor: RequestInterceptor,
         session: Session,
         reachability: NetworkReachability)
    {
        self.interceptor = interceptor
        self.session = session
        self.reachability = reachability
    }

    /// Default encoder to encode query parameters.
    static let urlParameterEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(keyEncoding: .useDefaultKeys))

    /// Default encoder to encode body parameters.
    static let jsonParameterEncoder: JSONParameterEncoder = {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .useDefaultKeys
        return JSONParameterEncoder(encoder: jsonEncoder)
    }()

    /// Default decoder to decode a response.
    static let dataDecoder: DataDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

// MARK: - Closures

extension API {
    /// Entry point for all generic requests.
    @discardableResult
    func request<T: Decodable>(_ apiRouter: APIRouter,
                               type: T.Type = T.self,
                               decoder: DataDecoder = API.dataDecoder,
                               completion: @escaping (Result<T, APIError>) -> Void) -> DataRequest?
    {
        guard reachability.isConnectedToNetwork() else {
            completion(.failure(.connectivity))
            return nil
        }

        return session.request(apiRouter,
                               interceptor: apiRouter.authorizationMethod != .none ? interceptor : nil)
            .validate { request, response, data in
                self.customValidation(request, response, data, decoder)
            }
            .validate()
            .responseDecodable(of: type, decoder: decoder, completionHandler: {
                let result = $0.result.mapError { self.mapError($0) }
                if case let .failure(apiError) = result {
                    if case let .underlying(error) = apiError,
                       let afError = error as? AFError,
                       afError.isRequestRetryError
                    {
                        self.logoutFailure?(error)
                        return
                    }
                }
                completion(result)
            })
    }

    @discardableResult
    func request(_ apiRouter: APIRouter,
                 completion: @escaping (Result<Data, APIError>) -> Void) -> DataRequest?
    {
        guard reachability.isConnectedToNetwork() else {
            completion(.failure(.connectivity))
            return nil
        }

        return session.request(apiRouter,
                               interceptor: apiRouter.authorizationMethod != .none ? interceptor : nil)
            .validate { request, response, data in
                self.customValidation(request, response, data, API.dataDecoder)
            }
            .validate()
            .response { response in
                if let error = response.error {
                    completion(.failure(self.mapError(error)))
                    return
                }

                if let data = response.data {
                    completion(.success(data))
                    return
                }

                completion(.success(Data()))
            }
    }
}

// MARK: - Swift Concurrency

extension API {
    func request<T: Decodable>(_ apiRouter: APIRouter,
                               type: T.Type = T.self,
                               decoder: DataDecoder = API.dataDecoder) async throws -> T
    {
        guard reachability.isConnectedToNetwork() else {
            throw APIError.connectivity
        }

        do {
            return try await session.request(apiRouter,
                                             interceptor: apiRouter.authorizationMethod != .none ? interceptor : nil)
                .validate { request, response, data in
                    self.customValidation(request, response, data, decoder)
                }
                .validate()
                .serializingDecodable(type, decoder: decoder)
                .value
        } catch {
            throw mapError(error)
        }
    }

    func request(_ apiRouter: APIRouter,
                 decoder: DataDecoder = API.dataDecoder) async throws -> Data
    {
        guard reachability.isConnectedToNetwork() else {
            throw APIError.connectivity
        }

        do {
            return try await session.request(apiRouter,
                                             interceptor: apiRouter.authorizationMethod != .none ? interceptor : nil)
                .validate { request, response, data in
                    self.customValidation(request, response, data, decoder)
                }
                .validate()
                .serializingData()
                .value
        } catch {
            throw mapError(error)
        }
    }
}

// MARK: - Custom Requests

extension API {
    func request(_ urlRequestConvertible: URLRequestConvertible,
                 needsAuthorization: Bool = false,
                 decoder: DataDecoder = API.dataDecoder) async throws -> Data
    {
        guard reachability.isConnectedToNetwork() else {
            throw APIError.connectivity
        }

        do {
            return try await session.request(urlRequestConvertible,
                                             interceptor: needsAuthorization ? interceptor : nil)
                .validate { request, response, data in
                    self.customValidation(request, response, data, decoder)
                }
                .validate()
                .serializingData()
                .value
        } catch {
            throw mapError(error)
        }
    }

    func request<T: Decodable>(_ urlRequestConvertible: URLRequestConvertible,
                               needsAuthorization: Bool = false,
                               type: T.Type = T.self,
                               decoder: DataDecoder = API.dataDecoder) async throws -> T
    {
        guard reachability.isConnectedToNetwork() else {
            throw APIError.connectivity
        }

        do {
            return try await session.request(urlRequestConvertible,
                                             interceptor: needsAuthorization ? interceptor : nil)
                .validate { request, response, data in
                    self.customValidation(request, response, data, decoder)
                }
                .validate()
                .serializingDecodable(type, decoder: decoder)
                .value
        } catch {
            throw mapError(error)
        }
    }
}

// MARK: - Custom Validation

extension API {
    /// Maps errors of different types retrieved from `validate` methods chain to `APIError`
    private func mapError(_ error: Error) -> APIError {
        if let urlError = error.asAFError?.underlyingError as? URLError, urlError.code == .notConnectedToInternet {
            return .connectivity
        }
        if let backendError = error.asAFError?.underlyingError as? APIError.BackendError {
            return .backend(backendError)
        }
        return .underlying(error)
    }

    /// Tries to decode backend JSON error object to `APIError.BackendError`
    private func customValidation(_: URLRequest?,
                                  _ response: HTTPURLResponse,
                                  _ data: Data?,
                                  _ decoder: DataDecoder) -> DataRequest.ValidationResult
    {
        if APIError.validatedStatusCodes.contains(response.statusCode), let data = data {
            let customError = try? decoder.decode(APIError.BackendError.self, from: data)
            if var error = customError {
                error.statusCode = response.statusCode
                return .failure(error)
            }
        }
        return .success(())
    }
}
