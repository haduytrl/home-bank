import Foundation
import NetworkProvider

struct NotificationRequest: APIRequest {
    typealias Response = DataWrapperDTO<NotificationResponse>
    
    var path: String { "/notificationList.json" }
}
