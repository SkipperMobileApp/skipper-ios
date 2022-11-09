import Alamofire
import Foundation

enum APIError: Error, LocalizedError {
    case custom(String)
    case backend(BackendError)
    case connectivity
    case underlying(Error)
    case requestCancelled(Error)

    struct BackendError: LocalizedError, Decodable {
        let message: String
        var statusCode: Int?

        var errorDescription: String? {
            return message
        }
    }

    static let refreshTokenStatusCodes: Set<Int> = Set([401])
    static let validatedStatusCodes: Set<Int> = Set((300 ..< 500).filter { !refreshTokenStatusCodes.contains($0) })

    var errorDescription: String? {
        switch self {
        case let .custom(message): return message
        case .connectivity: return R.string.localizable.errorConnectivity()
        case let .backend(error): return error.localizedDescription
        case let .underlying(error): return error.localizedDescription
        case let .requestCancelled(error): return error.localizedDescription
        }
    }
}

extension Result {
    /// Should be used to cast `Result` with specific error type (eq. `APIError`) back to generic `Error`
    func mapError() -> Result<Success, Error> {
        switch self {
        case let .success(data): return .success(data)
        case let .failure(error): return .failure(error)
        }
    }
}

extension Error {
    var asAPIError: APIError {
        return (self as? APIError) ?? .underlying(self)
    }
}
