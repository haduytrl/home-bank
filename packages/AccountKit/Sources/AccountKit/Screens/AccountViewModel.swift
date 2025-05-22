import Foundation
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider

// MARK: - Context & Output
extension AccountViewModel {
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
final class AccountViewModel: BaseViewModel {
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
extension AccountViewModel {
    func outputPublisher() -> AnyPublisher<Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }
}
