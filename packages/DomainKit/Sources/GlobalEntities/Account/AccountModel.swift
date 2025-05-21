import Foundation

public struct AccountModel {
    public let accountNo: String
    public let balance: Double
    public let currency: Currency?
    
    public init(
        accountNo: String,
        balance: Double,
        currency: Currency?
    ) {
        self.accountNo = accountNo
        self.balance = balance
        self.currency = currency
    }
}

public extension AccountModel {
    enum Currency: String {
        case usd = "USD"
        case khr = "KHR"
    }
}
