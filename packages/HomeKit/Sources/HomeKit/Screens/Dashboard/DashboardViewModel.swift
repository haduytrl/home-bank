import Foundation
import Combine
import CoreKit
import GlobalUsecase
import GlobalEntities
import NetworkProvider

// MARK: - Context & Output
extension DashboardViewModel {
    /// Context
    struct Context {
        let getUSDAccountsUsecase: GetUSDAccountsUsecase
        let getKHRAccountsUsecase: GetKHRAccountsUsecase
        let getFavouritesUsecase: GetFavouritesUsecase
        let getBannersUsecase: GetBannersUsecase
        let getNotificationsUsecase: GetNotificationsUsecase
        
        init(
            getUSDAccountsUsecase: GetUSDAccountsUsecase,
            getKHRAccountsUsecase: GetKHRAccountsUsecase,
            getFavouritesUsecase: GetFavouritesUsecase,
            getBannersUsecase: GetBannersUsecase,
            getNotificationsUsecase: GetNotificationsUsecase
        ) {
            self.getUSDAccountsUsecase = getUSDAccountsUsecase
            self.getKHRAccountsUsecase = getKHRAccountsUsecase
            self.getBannersUsecase = getBannersUsecase
            self.getFavouritesUsecase = getFavouritesUsecase
            self.getNotificationsUsecase = getNotificationsUsecase
        }
    }
    
    /// Output
    enum Output {
        case finish
        case routeToNotification(_ items: [NotificationModel])
    }
}

// MARK: - Section/Item
extension DashboardViewModel {
    /// Section list
    enum Section: Hashable {
        case profile
        case accountBalance
        case products
        case favourite
        case banner
        
        var estimatedItemHeight: CGFloat { 10.0 } // minimum item height
        var title: String? {
            switch self {
            case .favourite:
                return "My Favorite"
            default: return nil
            }
        }
    }
    
    /// Item of list
    enum Item: Hashable {
        case info(hasNotification: Bool)
        case balance(usd: Double, khr: Double)
        case productItem(_ item: ProductModel)
        case favouriteItem(_ item: FavouriteModel)
        case bannerItem(_ item: BannerModel)
        case emptyFavourite
    }
}

// MARK: - Main
final class DashboardViewModel: BaseViewModel {
    // Props
    private let context: Context
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var accountPage: (usd: Int, khr: Int) = (1, 1)
    private var notifications = [NotificationModel]()
    
    // State
    @Published private(set) var sections = [Section]()
    @Published private(set) var errorMessage: String?
    @Published private(set) var usdBalance: Double = 0.0
    @Published private(set) var khrBalance: Double = 0.0
    @Published private(set) var products: [ProductModel] = []
    @Published private(set) var favourites: [FavouriteModel] = []
    @Published private(set) var banners: [BannerModel] = []
    
    init(context: Context) {
        self.context = context
        self.sections = [.profile, .accountBalance, .products, .favourite, .banner]
    }
    
    override func reset() {
        super.reset()
        outputSubject.send(.finish)
    }
}

// MARK: - Call from outside
extension DashboardViewModel {
    func outputPublisher() -> AnyPublisher<Output, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    func notificationTapped() {
        outputSubject.send(.routeToNotification(notifications))
    }
    
    func firstLoadData() {
        executeMainTask { [weak self] in
            guard let self else { return }
            
            // Setup default products
            products = [
                ProductModel(id: "transfer", icon: "iconTransfer", title: "Transfer"),
                ProductModel(id: "payment", icon: "iconPayment", title: "Payment"),
                ProductModel(id: "utility", icon: "iconUtility", title: "Utility"),
                ProductModel(id: "qr_scan", icon: "iconQRScan", title: "QR pay scan"),
                ProductModel(id: "my_qr", icon: "iconQRCode", title: "My QR code"),
                ProductModel(id: "topup", icon: "iconTopup", title: "Top up")
            ]
            
            // Fetch all data
            try await fetchAllDataConcurrently()
            
        } onError: { [weak self] error in
            guard let self, !Task.isCancelled else { return }
            await self.handleError(error)
        }
    }
    
    func performRefresh(_ completion: @escaping () -> Void) {
        executeMainTask { [weak self] in
            guard let self = self else { return }
            
            try await performFetchData(completion)
            
            // completion
            await MainActor.run {
                completion()
            }
        } onError: { [weak self] error in
            guard let self = self, !Task.isCancelled else { return }
            await MainActor.run { completion() }
            await self.handleError(error)
        }
        
    }
}

// MARK: Private method

private extension DashboardViewModel {
    func performFetchData(_ completion: @escaping () -> Void) async throws {
        try await withThrowingTaskGroup(of: Void.self) { [weak self] group in
            guard let self else { return }
            
            // USD accounts
            group.addTask {
                do {
                    let result = try await self.context.getUSDAccountsUsecase.execute(page: self.accountPage.usd)
                    self.usdBalance = result.reduce(0) { $0 + $1.balance }
                } catch {
                    await self.handleError(error)
                }
            }
            
            // KHR accounts
            group.addTask {
                do {
                    let result = try await self.context.getKHRAccountsUsecase.execute(page: self.accountPage.khr)
                    self.khrBalance = result.reduce(0) { $0 + $1.balance }
                } catch {
                    await self.handleError(error)
                }
            }
            
            // Favorites
            group.addTask {
                do {
                    let result = try await self.context.getFavouritesUsecase.execute()
                    self.favourites = result
                } catch {
                    await self.handleError(error)
                }
            }
            
            // Notification
            group.addTask {
                do {
                    let result = try await self.context.getNotificationsUsecase.execute()
                    
                    guard !result.isEmpty else { throw APIError.mappingError }
                    
                    self.notifications = result
                } catch {
                    await self.handleError(error)
                }
            }
            
            // wait for both tasks
            try await group.waitForAll()
        }
        
        await MainActor.run {
            completion()
        }
    }
    
    func fetchAllDataConcurrently() async throws {
        await withThrowingTaskGroup(of: Void.self) { [weak self] group in
            guard let self else { return }
            
            group.addTask {
                do {
                    let result = try await self.context.getUSDAccountsUsecase.execute(page: self.accountPage.usd)
                    self.usdBalance = result.reduce(0) { $0 + $1.balance }
                    self.accountPage.usd += 1
                } catch {
                    await self.handleError(error)
                }
            }
            
            group.addTask {
                do {
                    let result = try await self.context.getKHRAccountsUsecase.execute(page: self.accountPage.khr)
                    self.khrBalance = result.reduce(0) { $0 + $1.balance }
                    self.accountPage.khr += 1
                } catch {
                    await self.handleError(error)
                }
            }
            
            group.addTask {
                do {
                    let result = try await self.context.getBannersUsecase.execute()
                    self.banners = result.sorted { $0.order < $1.order }
                } catch {
                    await self.handleError(error)
                }
            }
        }
    }
    
    func handleError(_ error: Error) async {
        errorMessage = (error as? APIError)?.errorDescription
        ?? error.localizedDescription
    }
}
