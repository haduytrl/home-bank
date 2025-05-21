import Foundation
import GlobalEntities
import DomainRepositories

public protocol GetNotificationsUsecase {
    func execute() async throws -> [NotificationModel]
}

public final class GetNotificationsUsecaseImpl: GetNotificationsUsecase {
    private let repository: HomeBankRepository
    
    public init(repository: HomeBankRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [NotificationModel] {
        try await repository.fetchNotifications()
    }
}
