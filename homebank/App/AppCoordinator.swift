import UIKit
import CoreKit
import HomeGitKit
import NetworkProvider

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let apiClient = APIClient(
            baseURL: Environment.Config.baseURL,
            defaultHeaders: Environment.Config.defaultHeaders
        )
        let dashboardCoordinator = DashboardCoordinator(navigationController: navigationController, apiClient: apiClient)
        dashboardCoordinator.parentCoordinator = self
        childCoordinators.append(dashboardCoordinator)
        dashboardCoordinator.start()
    }
}
