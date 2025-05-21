import Foundation
import NetworkProvider
import GlobalEntities
import DomainRepositories

// MARK: - Main
public class HomeRepositoryImpl {
    private let apiClient: APIClientProtocol
    
    public init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
}

// MARK: - Handle fetch service

extension HomeRepositoryImpl: HomeBankRepository {
    public func fetchUSDSaving(page: Int) async throws -> [AccountModel] {
        let request = SavingAccountRequest(page: page, currencyType: .usd)
        let response = try await apiClient.send(request)
        
        guard let list = response.result?.savingsList else { throw APIError.invalidResponse(statusCode: nil) }
        
        return list.map(\.parseToModel)
    }
    
    public func fetchUSDFixedDeposited(page: Int) async throws -> [AccountModel] {
        let request = FixedAccountRequest(page: page, currencyType: .usd)
        let response = try await apiClient.send(request)
        
        guard let list = response.result?.fixedDepositList else { throw APIError.invalidResponse(statusCode: nil) }
        
        return list.map(\.parseToModel)
    }
    
    public func fetchUSDDigital(page: Int) async throws -> [AccountModel] {
        let request = DigitalAccountRequest(page: page, currencyType: .usd)
        let response = try await apiClient.send(request)
        
        guard let list = response.result?.digitalList else { throw APIError.invalidResponse(statusCode: nil) }
        
        return list.map(\.parseToModel)
    }
    
    public func fetchKHRSaving(page: Int) async throws -> [AccountModel] {
        let request = SavingAccountRequest(page: page, currencyType: .khr)
        let response = try await apiClient.send(request)
        
        guard let list = response.result?.savingsList else { throw APIError.invalidResponse(statusCode: nil) }
        
        return list.map(\.parseToModel)
    }
    
    public func fetchKHRFixedDeposited(page: Int) async throws -> [AccountModel] {
        let request = FixedAccountRequest(page: page, currencyType: .khr)
        let response = try await apiClient.send(request)
        
        guard let list = response.result?.fixedDepositList else { throw APIError.invalidResponse(statusCode: nil) }
        
        return list.map(\.parseToModel)
    }
    
    public func fetchKHRDigital(page: Int) async throws -> [AccountModel] {
        let request = DigitalAccountRequest(page: page, currencyType: .khr)
        let response = try await apiClient.send(request)
        
        guard let list = response.result?.digitalList else { throw APIError.invalidResponse(statusCode: nil) }
        
        return list.map(\.parseToModel)
    }
    
    public func fetchFavorites() async throws -> [FavouriteModel] {
        let request = FavouriteRequest()
        let response = try await apiClient.send(request)
        guard let list = response.result?.favoriteList else { throw APIError.invalidResponse(statusCode: nil) }
        return list.map( \.parseToModel)
    }
    
    public func fetchBanners() async throws -> [BannerModel] {
        let request = BannerRequest()
        let response = try await apiClient.send(request)
        guard let list = response.result?.bannerList else { throw APIError.invalidResponse(statusCode: nil) }
        return list.map( \.parseToModel)
    }
    
    public func fetchNotifications() async throws -> [NotificationModel] {
        let request = NotificationRequest()
        let response = try await apiClient.send(request)
        guard let list = response.result?.messages else { throw APIError.invalidResponse(statusCode: nil) }
        return list.map( \.parseToModel)
    }
}
