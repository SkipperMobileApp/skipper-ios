import Foundation

enum DeepLink: Equatable {
    enum Constants {}

    static func from(url: URL) -> DeepLink? {
        guard let _ = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        return nil
    }
}

extension URLComponents {
    func queryValue(forKey key: String) -> String? {
        queryItems?.first(where: { $0.name == key })?.value
    }
}
