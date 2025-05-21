import Foundation

public struct ProductModel: Hashable {
    private let uuid: String
    public let id: String
    public let icon: String
    public let title: String
    
    public init(id: String, icon: String, title: String) {
        self.uuid = UUID().uuidString
        self.id = id
        self.icon = icon
        self.title = title
    }
}
