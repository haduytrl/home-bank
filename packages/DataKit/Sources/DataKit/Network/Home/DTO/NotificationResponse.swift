import Foundation
import GlobalEntities

struct NotificationResponse: Decodable {
    let messages: [Item]
}

extension NotificationResponse {
    struct Item: Decodable {
        let status: Bool?
        let updateDateTime: String?
        let title: String?
        let message: String?
        
        var parseToModel: NotificationModel {
            .init(
                isRead: status ?? false,
                lastUpdated: updateDateTime ?? "",
                title: title ?? "",
                message: message ?? ""
            )
        }
    }
}
