import Foundation

enum CurrencyRequestType: Equatable {
    case usd , khr
    
    var rawValue: String {
        switch self {
        case .usd:
            return "usd"
        case .khr:
            return "khr"
        }
    }
}
