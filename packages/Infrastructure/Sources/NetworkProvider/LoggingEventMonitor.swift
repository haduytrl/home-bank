import Foundation

public protocol EventMonitor {
    func requestSend(_ request: URLRequest)
    func responseReceived(_ data: Data, response: URLResponse)
}

final class LoggingEventMonitor: EventMonitor {
    init() {}
    func requestSend(_ request: URLRequest) {
        #if DEBUG
        debugPrint("🌐 =================== Network Request ===================")
        debugPrint()
        debugPrint("URL: \(request.url?.absoluteString ?? "Invalid URL")")
        debugPrint("Method: \(request.httpMethod ?? "Unknown")")
        if let headers = request.allHTTPHeaderFields {
            debugPrint("Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            debugPrint("Body: \(bodyString)")
        }
        debugPrint()
        debugPrint("=====================================================")
        #endif
    }
    
    func responseReceived(_ data: Data, response: URLResponse) {
        #if DEBUG
        debugPrint()
        debugPrint("📥 =================== Network Response ==================")
        debugPrint()
        if let httpResponse = response as? HTTPURLResponse {
            debugPrint("Status Code: \(httpResponse.statusCode)")
            debugPrint("Headers: \(httpResponse.allHeaderFields)")
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            debugPrint("Response Body: \(jsonString)")
        }
        debugPrint()
        debugPrint("=====================================================\n")
        #endif
    }
}
