import Foundation

public final class APIClient: APIClientProtocol {
    private let session: URLSessionProtocol
    private let baseURL: URL
    private let defaultHeaders: [String: String]?
    private let eventMonitors: [EventMonitor]
    
    /// - baseURL: e.g. "https://api.example.com"
    /// - defaultHeaders: common headers (e.g. auth tokens)
    /// - session: inject URLSession or a mock
    /// - logger: your `EventMonitor` (defaults to `LoggingEventMonitor`)
    public init(
        baseURL: String,
        defaultHeaders: [String: String]? = nil,
        session: URLSessionProtocol = URLSession.shared,
        eventMonitors: [EventMonitor] = []
    ) {
        self.baseURL = URL(string: baseURL)!
        self.defaultHeaders = defaultHeaders
        self.session = session
        self.eventMonitors = eventMonitors.isEmpty ? [LoggingEventMonitor()] : eventMonitors
    }
    
    public func send<T: APIRequest>(_ apiReq: T) async throws -> T.Response {
        // 1) Build URLRequest
        var request = try makeURLRequest(for: apiReq)
        
        // 2) Merge headers
        if let allHeaders = apiReq.headers ?? defaultHeaders, !allHeaders.isEmpty {
            allHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        // 3) Attach body (JSON-encode either `body` or `parameters`)
        if apiReq.method != .get {
            if let enc = apiReq.body {
                let encoded = try JSONEncoder().encode(AnyEncodable(encodable: enc))
                request.httpBody = encoded
            } else if let params = apiReq.parameters {
                let encoded = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = encoded
            }
        }
        
        // 4) Log the outgoing request
        eventMonitors.forEach { $0.requestSend(request) }
        
        // 5) Execute
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch let urlErr as URLError {
            throw APIError.networkError(urlErr.localizedDescription)
        } catch {
            throw APIError.unknownError(error.localizedDescription)
        }
        
        // 6) Log the incoming response
        eventMonitors.forEach { $0.responseReceived(data, response: response) }
        
        // 7) Validate status code
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(statusCode: nil)
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.invalidResponse(statusCode: http.statusCode)
        }
        
        // 8) Decode
        do {
            return try JSONDecoder().decode(T.Response.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}

private extension APIClient {
    func makeURLRequest<T: APIRequest>(for apiReq: T) throws -> URLRequest {
        // 1) Build the URL + query items for GET if needed
        guard var comps = URLComponents(
            url: baseURL.appendingPathComponent(apiReq.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidResponse(statusCode: nil)
        }
        
        if apiReq.method == .get, let params = apiReq.parameters {
            comps.queryItems = params.map { .init(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = comps.url else {
            throw APIError.invalidResponse(statusCode: nil)
        }
        
        // 2) Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = apiReq.method.rawValue
        
        return request
    }
    
    /// Erase `Encodable` so we can JSON-encode any `body`
    struct AnyEncodable: Encodable {
        let encodable: Encodable
        func encode(to encoder: Encoder) throws {
            try encodable.encode(to: encoder)
        }
    }
}
