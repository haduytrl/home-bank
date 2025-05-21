import Foundation
import GlobalEntities
import DomainRepositories

public protocol GetFavouritesUsecase {
    func execute() async throws -> [FavouriteModel]
}

public final class GetFavouritesUsecaseImpl: GetFavouritesUsecase {
    private let repository: HomeBankRepository
    
    public init(repository: HomeBankRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [FavouriteModel] {
        try await repository.fetchFavorites()
    }
}
