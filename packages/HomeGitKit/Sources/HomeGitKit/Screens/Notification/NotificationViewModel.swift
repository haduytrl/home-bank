import Foundation
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider

// MARK: - Context & Output
extension NotificationViewModel {
    /// Context
    struct Context {
        let notifications: [NotificationModel]
        let getNotificationsUsecase: GetNotificationsUsecase

        init(
            notifications: [NotificationModel],
            getNotificationsUsecase: GetNotificationsUsecase
        ) {
            self.notifications = notifications
            self.getNotificationsUsecase = getNotificationsUsecase
        }
    }

    /// Output
    enum Output {
        case finish
    }
}

// MARK: - Section/Item
extension NotificationViewModel {
    /// Section list
    enum Section: Hashable { case main }
    
    /// Item of list
    enum Item: Hashable {
        case notification(_ item: NotificationModel)
    }
}


// MARK: - Main
final class NotificationViewModel: BaseViewModel {
    // Props
    private let context: Context
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // State
    @Published private(set) var notifications = [NotificationModel]()
    @Published private(set) var errorMessage: String?
    
    init(context: Context) {
        self.context = context
    }
    
    override func reset() {
        super.reset()
        outputSubject.send(.finish)
    }
}

// MARK: - Call from outside
extension NotificationViewModel {
    func outputPublisher() -> AnyPublisher<Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    func firstLoadData() {
        notifications = context.notifications
    }
    
    func refreshData(_ completion: (() -> Void)? = nil) {
        executeMainTask { [weak self] in
            guard let self else { return }
            let result = try await context.getNotificationsUsecase.execute()
            
            guard !result.isEmpty else { throw APIError.mappingError }
            
            notifications = result
            
            await MainActor.run {
                completion?()
            }
        } onError: { [weak self] error in
            guard let self, !Task.isCancelled else { return }
            notifications = []
            errorMessage = (error as? APIError)?.errorDescription
                            ?? error.localizedDescription
            
            await MainActor.run {
                completion?()
            }
        }
    }
}
