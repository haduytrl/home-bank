import Foundation
import NetworkProvider

struct FavouriteRequest: APIRequest {
    typealias Response = DataWrapperDTO<FavouriteResponse>
    
    var path: String { "/favoriteList.json" }
}
