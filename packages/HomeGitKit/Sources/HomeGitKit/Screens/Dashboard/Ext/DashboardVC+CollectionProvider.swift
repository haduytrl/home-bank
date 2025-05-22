import CoreKit
import UIKit
import GlobalEntities

// MARK: - Builder
extension DashboardViewController: DiffableCollectionProvider {
    typealias VM = DashboardViewModel
    typealias Section = VM.Section
    typealias Item = VM.Item
    typealias CellType = UICollectionViewCell
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<VM.Item>
    
    // Init data source
    func makeDataSource(for collectionView: UICollectionView) -> DataSource {
        // Create cell registrations
        let profileRegistration        = makeProfileCellRegistration()
        let balanceRegistration        = makeBalanceCellRegistration()
        let productRegistration        = makeProductCellRegistration()
        let favouriteRegistration      = makeFavouriteCellRegistration()
        let emptyFavouriteRegistration = makeEmptyFavouriteCellRegistration()
        let bannerRegistration         = makeBannerCellRegistration()
        
        // Create header/footer registrations
        let headerRegistration = makeTitleHeaderRegistration()
        let footerRegistration = makePageControlFooterRegistration()
        
        // Cell registration closure
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                var cellRegistration: CellRegistration
                
                switch item {
                case .info:
                    cellRegistration = profileRegistration
                    
                case .balance:
                    cellRegistration = balanceRegistration
                    
                case .productItem:
                    cellRegistration = productRegistration
                    
                case .favouriteItem:
                    cellRegistration = favouriteRegistration
                    
                case .bannerItem:
                    cellRegistration = bannerRegistration
                case .emptyFavourite:
                    cellRegistration = emptyFavouriteRegistration
                }
                
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            })
        
        // Setup supplementary views
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return nil }
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
                
            case UICollectionView.elementKindSectionFooter:
                let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
                
                guard section == .banner else { return nil }
                let footer = collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
                pageControlFooterView = footer
                return footer
                
            default:
                return nil
            }
        }
        
        return dataSource
    }
    
    // Create general layout
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            
            let section = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            let items = dataSource.snapshot().itemIdentifiers(inSection: section)
            
            guard !items.isEmpty else { return nil }
            
            switch section {
            case .profile:
                return createProfileSection()
            case .accountBalance:
                return createBalanceSection()
            case .products:
                return createProductsSection()
            case .favourite:
                let isEmpty = items.first == .emptyFavourite
                return createFavouriteSection(isEmpty: isEmpty)
            case .banner:
                return createBannerSection()
            }
        }
        
        return layout
    }
    
    // Apply sections
    func applySectionsSnapshot(with sections: [VM.Section]) {
        var snapshot = Snapshot()
        snapshot.appendSections(viewModel.sections)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Making Snapshot
extension DashboardViewController {
    func makeSnapshotOfProfile(hasNotification: Bool, isAnim: Bool = true) {
        var snapshot = SectionSnapshot()
        snapshot.append([.info(hasNotification: hasNotification)])
        dataSource.apply(snapshot, to: .profile, animatingDifferences: true)
    }
    
    func makeSnapshotOfBalance(usd: Double, khr: Double, isAnim: Bool = true) {
        var snapshot = SectionSnapshot()
        snapshot.append([.balance(usd: usd, khr: khr)])
        dataSource.apply(snapshot, to: .accountBalance, animatingDifferences: true)
    }
    
    func makeSnapshotOfProducts(_ products: [ProductModel], isAnim: Bool = true) {
        let items: [VM.Item] = products.map { VM.Item.productItem($0) }
        var snapshot = SectionSnapshot()
        snapshot.append(items)
        dataSource.apply(snapshot, to: .products, animatingDifferences: true)
    }
    
    func makeSnapshotOfFavorites(_ favorites: [FavouriteModel], isAnim: Bool = true) {
        var snapshot = SectionSnapshot()

        if !favorites.isEmpty {
            let items: [VM.Item] = favorites.map { VM.Item.favouriteItem($0) }
            snapshot.append(items)
        } else {
            snapshot.append([.emptyFavourite])
        }
        
        dataSource.apply(snapshot, to: .favourite, animatingDifferences: isAnim)
    }
    
    func makeSnapshotOfBanners(_ banners: [BannerModel], isAnim: Bool = true) {
        let items: [VM.Item] = banners.map { VM.Item.bannerItem($0) }
        var snapshot = SectionSnapshot()
        snapshot.append(items)
        dataSource.apply(snapshot, to: .banner, animatingDifferences: true)
    }
}
