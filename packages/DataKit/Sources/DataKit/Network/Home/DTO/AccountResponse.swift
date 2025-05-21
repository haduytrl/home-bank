import Foundation
import GlobalEntities

struct AccountResponse: Decodable {
    let account: String?
    let curr: String?
    let balance: Double?
}

extension AccountResponse {
    var parseToModel: AccountModel {
        let currency = AccountModel.Currency(rawValue: curr ?? "")
        return .init(
            accountNo: account ?? "",
            balance: balance ?? 0.0,
            currency: currency
        )
    }
}
