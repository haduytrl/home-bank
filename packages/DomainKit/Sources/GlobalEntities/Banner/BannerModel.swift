import Foundation

public struct BannerModel: Hashable {
    private let uuid: String
    public let order: Int
    public let url: String
    
    public init(order: Int, url: String) {
        self.uuid = UUID().uuidString
        self.order = order
        self.url = url
    }
}
