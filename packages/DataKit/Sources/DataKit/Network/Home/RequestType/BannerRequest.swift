import Foundation
import NetworkProvider

struct BannerRequest: APIRequest {
    typealias Response = DataWrapperDTO<BannerResponse>
    
    var path: String { "/banner.json" }
}
