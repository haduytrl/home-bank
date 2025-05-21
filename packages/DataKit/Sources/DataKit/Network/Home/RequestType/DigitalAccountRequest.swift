import Foundation
import NetworkProvider

struct DigitalAccountRequest: APIRequest {
    typealias Response = DataWrapperDTO<DigitalResponse>
    
    private let page: Int
    private let currType: CurrencyRequestType
    
    init(
        page: Int,
        currencyType: CurrencyRequestType
    ) {
        self.page = page
        self.currType = currencyType
    }
    
    var path: String { "/\(currType.rawValue + "Digital" + String(page)).json" }
}
