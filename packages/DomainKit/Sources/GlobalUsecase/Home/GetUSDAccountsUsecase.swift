import Foundation
import GlobalEntities
import DomainRepositories

public protocol GetUSDAccountsUsecase {
    func execute(page: Int) async throws -> [AccountModel]
}

public final class GetUSDAccountUsecaseImpl: GetUSDAccountsUsecase {
    private let repository: HomeBankRepository
    
    public init(repository: HomeBankRepository) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> [AccountModel] {
        async let savings = repository.fetchUSDSaving(page: page)
        async let fixed = repository.fetchUSDFixedDeposited(page: page)
        async let digital = repository.fetchUSDDigital(page: page)
        
        let (savingsResult, fixedResult, digitalResult) = try await (savings, fixed, digital)
        let newResult = savingsResult + fixedResult + digitalResult
        
        return newResult.filter { $0.currency == .usd }
    }
}
