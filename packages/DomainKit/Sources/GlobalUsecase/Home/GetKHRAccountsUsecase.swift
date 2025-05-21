import Foundation
import GlobalEntities
import DomainRepositories

public protocol GetKHRAccountsUsecase {
    func execute(page: Int) async throws -> [AccountModel]
}

public final class GetKHRAccountUsecaseImpl: GetKHRAccountsUsecase {
    private let repository: HomeBankRepository
    
    public init(repository: HomeBankRepository) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> [AccountModel] {
        async let savings = repository.fetchKHRSaving(page: page)
        async let fixed = repository.fetchKHRFixedDeposited(page: page)
        async let digital = repository.fetchKHRDigital(page: page)
        
        let (savingsResult, fixedResult, digitalResult) = try await (savings, fixed, digital)
        let newResult = savingsResult + fixedResult + digitalResult
        
        return newResult.filter { $0.currency == .khr }
    }
}
