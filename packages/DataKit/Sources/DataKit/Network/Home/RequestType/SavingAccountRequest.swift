import Foundation
import NetworkProvider

struct SavingAccountRequest: APIRequest {
    typealias Response = DataWrapperDTO<SavingAccountReponse>
    
    private let page: Int
    private let currType: CurrencyRequestType
    
    init(
        page: Int,
        currencyType: CurrencyRequestType
    ) {
        self.page = page
        self.currType = currencyType
    }
    
    var path: String { "/\(currType.rawValue + "Savings" + String(page)).json" }
}
