import Foundation
import NetworkProvider

struct FixedAccountRequest: APIRequest {
    typealias Response = DataWrapperDTO<FixDepositedResponse>
    
    private let page: Int
    private let currType: CurrencyRequestType
    
    init(
        page: Int,
        currencyType: CurrencyRequestType
    ) {
        self.page = page
        self.currType = currencyType
    }
    
    var path: String { "/\(currType.rawValue + "Fixed" + String(page)).json" }
}
