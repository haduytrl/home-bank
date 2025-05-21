import Foundation
import GlobalEntities

struct BannerResponse: Decodable {
    let bannerList: [Item]
}

extension BannerResponse {
    struct Item: Decodable {
        let adSeqNo: Int?
        let linkUrl: String?
        
        var parseToModel: BannerModel {
            .init(order: adSeqNo ?? -1, url: linkUrl ?? "")
        }
    }
}
