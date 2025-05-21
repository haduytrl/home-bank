import Foundation
import GlobalEntities

// Interfaces
public protocol HomeBankRepository {
    func fetchUSDSaving(page: Int) async throws -> [AccountModel]
    func fetchUSDFixedDeposited(page: Int) async throws -> [AccountModel]
    func fetchUSDDigital(page: Int) async throws -> [AccountModel]

    func fetchKHRSaving(page: Int) async throws -> [AccountModel]
    func fetchKHRFixedDeposited(page: Int) async throws -> [AccountModel]
    func fetchKHRDigital(page: Int) async throws -> [AccountModel]
    
    func fetchFavorites() async throws -> [FavouriteModel]
    func fetchBanners() async throws -> [BannerModel]
    func fetchNotifications() async throws -> [NotificationModel]
}
