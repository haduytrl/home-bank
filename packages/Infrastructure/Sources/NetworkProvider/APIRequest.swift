import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol APIRequest {
    associatedtype Response: Decodable

    /// e.g. "/users"
    var path: String { get }

    var method: HTTPMethod { get }

    /// URL- or body-parameters
    var parameters: [String: Any]? { get }

    /// `Encodable` request body (takes priority over `parameters`)
    var body: Encodable? { get }

    /// Extra headers (merged with defaults)
    var headers: [String: String]? { get }
}

// MARK: - Default
public extension APIRequest {
    var method: HTTPMethod            { .get }
    var parameters: [String: Any]?    { nil }
    var body: Encodable?              { nil }
    var headers: [String: String]?    { nil }
}
