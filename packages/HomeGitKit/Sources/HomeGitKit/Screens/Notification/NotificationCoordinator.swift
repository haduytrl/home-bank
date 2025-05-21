import CoreKit
import DataKit
import GlobalEntities
import GlobalUsecase
import DomainRepositories
import UIKit
import Combine
import NetworkProvider

public final class NotificationCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var parentCoordinator: Coordinator?
    public var childCoordinators: [Coordinator] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClientProtocol
    private let notifications: [NotificationModel]
    
    public init(
        navigationController: UINavigationController,
        apiClient: APIClientProtocol,
        notifications: [NotificationModel]
    ) {
        self.navigationController = navigationController
        self.apiClient = apiClient
        self.notifications = notifications
    }
    
    public func start() {
        let repository = HomeRepositoryImpl(apiClient: apiClient)
        let getNotificationsUsecase = GetNotificationsUsecaseImpl(repository: repository)
        let viewModel = NotificationViewModel(context: .init(
            notifications: notifications,
            getNotificationsUsecase: getNotificationsUsecase
        ))
        let ctr = NotificationViewController(viewModel: viewModel)
        
        viewModel.outputPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self else { return }
                switch output {
                case .finish:
                    finish()
                }
            }.store(in: &cancellables)
        
        navigationController.pushViewController(ctr, animated: true)
    }
}
