import Foundation
import GlobalEntities
import DomainRepositories

public protocol GetBannersUsecase {
    func execute() async throws -> [BannerModel]
}

public final class GetBannersUsecaseImpl: GetBannersUsecase {
    private let repository: HomeBankRepository
    
    public init(repository: HomeBankRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [BannerModel] {
        try await repository.fetchBanners()
    }
}
