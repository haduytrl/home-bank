import Foundation
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider

// MARK: - Context & Output
extension UserServiceViewModel {
    /// Context
    struct Context {
        init() {}
    }

    /// Output
    enum Output {
        case finish
    }
}

// MARK: - Main
final class UserServiceViewModel: BaseViewModel {
    // Props
    private let context: Context
    private let outputSubject = PassthroughSubject<Output, Never>()
    
    // State
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
extension UserServiceViewModel {
    func outputPublisher() -> AnyPublisher<Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }
}
