import Foundation
import GlobalEntities

struct FavouriteResponse: Decodable {
    let favoriteList: [Item]
}

extension FavouriteResponse {
    struct Item: Decodable {
        let nickname: String?
        let transType: String?
        
        var parseToModel: FavouriteModel {
            let type = FavouriteModel.TransferType(rawValue: transType ?? "")
            
            return .init(
                username: nickname ?? "",
                transType: type ?? .unknown
            )
        }
    }
}
