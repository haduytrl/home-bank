import CoreKit
import DataKit
import GlobalUsecase
import GlobalEntities
import DomainRepositories
import UIKit
import Combine
import NetworkProvider

public final class DashboardCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var parentCoordinator: Coordinator?
    public var childCoordinators: [Coordinator] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClientProtocol
    
    public init(
        navigationController: UINavigationController,
        apiClient: APIClientProtocol
    ) {
        self.navigationController = navigationController
        self.apiClient = apiClient
    }
    
    public func start() {
        let repository = HomeRepositoryImpl(apiClient: apiClient)
        let getUSDAccountsUsecase = GetUSDAccountUsecaseImpl(repository: repository)
        let getKHRAccountsUsecase = GetKHRAccountUsecaseImpl(repository: repository)
        let getFavouritesUsecase = GetFavouritesUsecaseImpl(repository: repository)
        let getBannersUsecase = GetBannersUsecaseImpl(repository: repository)
        let getNotificationsUsecase = GetNotificationsUsecaseImpl(repository: repository)
        let viewModel = DashboardViewModel(context: .init(
            getUSDAccountsUsecase: getUSDAccountsUsecase,
            getKHRAccountsUsecase: getKHRAccountsUsecase,
            getFavouritesUsecase: getFavouritesUsecase,
            getBannersUsecase: getBannersUsecase,
            getNotificationsUsecase: getNotificationsUsecase))
        let ctr = DashboardViewController(viewModel: viewModel)
        
        viewModel.outputPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self else { return }
                switch output {
                case .finish:
                    finish()
                case let .routeToNotification(items):
                    routeToNotification(items)
                }
            }.store(in: &cancellables)
        
        navigationController.pushViewController(ctr, animated: true)
    }
}

// MARK: - Cross coordinators

private extension DashboardCoordinator {
    func routeToNotification(_ items: [NotificationModel]) {
        let coordinator = NotificationCoordinator(
            navigationController: navigationController,
            apiClient: apiClient,
            notifications: items
        )
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}
