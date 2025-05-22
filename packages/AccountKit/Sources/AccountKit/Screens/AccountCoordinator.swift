import CoreKit
import DataKit
import GlobalEntities
import GlobalUsecase
import DomainRepositories
import UIKit
import Combine
import NetworkProvider

public final class AccountCoordinator: Coordinator {
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
    
    public func start() {}
    
    public var initialViewController: UIViewController {
        let viewModel = AccountViewModel(context: .init())
        let ctr = AccountViewController(viewModel: viewModel)
        
        viewModel.outputPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self else { return }
                switch output {
                case .finish:
                    finish()
                }
            }.store(in: &cancellables)
        
        return ctr
    }
}
