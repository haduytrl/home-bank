import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    
    var initialViewController: UIViewController { get }
}

// MARK: - Default

public extension Coordinator {
    func finish() {
        parentCoordinator?.childDidFinish(self) // Self is current coordinator
    }
    
    var initialViewController: UIViewController {
        fatalError("Must override initialViewController in subclasses")
    }
}

// MARK: - Helper

private extension Coordinator {
    func childDidFinish(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
