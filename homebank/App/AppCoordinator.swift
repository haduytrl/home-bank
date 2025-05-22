import UIKit
import CoreKit
import NetworkProvider
import HomeKit
import AccountKit
import LocationKit
import UserServiceKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController { UINavigationController() }
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    let apiClient = APIClient(
        baseURL: Environment.Config.baseURL,
        defaultHeaders: Environment.Config.defaultHeaders
    )
    
    func start() {}
    
    var initialViewController: UIViewController {
        let tab1 = makeHomeNavController()
        let tab2 = makeAccountNavController()
        let tab3 = makeLocationNavController()
        let tab4 = makeUserServiceNavController()
        
        return MainTabBarViewController(viewControllers: [tab1, tab2, tab3, tab4])
    }
}

// MARK: - Making tab navigation coordinator

private extension AppCoordinator {
    // HomeKit
    func makeHomeNavController() -> UINavigationController {
        let nav = UINavigationController()
        let dashboardCoordinator = DashboardCoordinator(navigationController: nav, apiClient: apiClient)
        dashboardCoordinator.parentCoordinator = self
        childCoordinators.append(dashboardCoordinator)
        
        // return the initial VC from the coordinator:
        nav.viewControllers = [dashboardCoordinator.initialController]
        nav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill")?.withTintColor(.gray7),
            selectedImage: UIImage(named: "iconHome")?.withRenderingMode(.alwaysOriginal)
        )
        return nav
    }
    
    // AccountKit
    func makeAccountNavController() -> UINavigationController {
        let nav = UINavigationController()
        let accountCoordinator = AccountCoordinator(navigationController: nav, apiClient: apiClient)
        accountCoordinator.parentCoordinator = self
        childCoordinators.append(accountCoordinator)
        
        nav.viewControllers = [accountCoordinator.initialViewController]
        nav.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "iconAccount")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "iconAccount")?.withTintColor(.orange1, renderingMode: .alwaysTemplate)
        )
        return nav
    }
    
    // LocationKit
    func makeLocationNavController() -> UINavigationController {
        let nav = UINavigationController()
        let accountCoordinator = LocationCoordinator(navigationController: nav, apiClient: apiClient)
        accountCoordinator.parentCoordinator = self
        childCoordinators.append(accountCoordinator)
        
        nav.viewControllers = [accountCoordinator.initialViewController]
        nav.tabBarItem = UITabBarItem(
            title: "Location",
            image: UIImage(named: "iconLocation")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "iconLocation")?.withTintColor(.orange1, renderingMode: .alwaysTemplate)
        )
        return nav
    }
    
    // UserServiceKit
    func makeUserServiceNavController() -> UINavigationController {
        let nav = UINavigationController()
        let accountCoordinator = UserServiceCoordinator(navigationController: nav, apiClient: apiClient)
        accountCoordinator.parentCoordinator = self
        childCoordinators.append(accountCoordinator)
        
        nav.viewControllers = [accountCoordinator.initialViewController]
        nav.tabBarItem = UITabBarItem(
            title: "Service",
            image: UIImage(systemName: "person.2.fill")?.withTintColor(.gray7),
            selectedImage: UIImage(systemName: "person.2.fill")?.withTintColor(.orange1, renderingMode: .alwaysTemplate)
        )
        return nav
    }
}
