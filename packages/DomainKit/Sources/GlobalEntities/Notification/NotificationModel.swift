import Foundation

public struct NotificationModel: Hashable {
    private let uuid: String
    public let isRead: Bool
    public let lastUpdated: String
    public let title: String
    public let message: String
    
    public init(
        isRead: Bool,
        lastUpdated: String,
        title: String,
        message: String
    ) {
        self.uuid = UUID().uuidString
        self.isRead = isRead
        self.lastUpdated = lastUpdated
        self.title = title
        self.message = message
    }
}
