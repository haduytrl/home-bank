import Foundation
import UIKit

// MARK: - Cell Registrations
extension DashboardViewController {
    func makeProfileCellRegistration() -> CellRegistration {
        return .init { cell, _, item in
            guard case let .info(hasNoti) = item else { return }
            var profileCell = ProfileContentConfiguration(hasNotifications: hasNoti)
            profileCell.notificationAction = { [weak self] in
                self?.viewModel.notificationTapped()
            }
            cell.contentConfiguration = profileCell
        }
    }
    
    func makeBalanceCellRegistration() -> CellRegistration {
        return .init { cell, _, item in
            guard case let .balance(usd, khr) = item else { return }
            cell.contentConfiguration = BalanceContentConfiguration(usdBalance: usd, khrBalance: khr)
        }
    }
    
    func makeProductCellRegistration() -> CellRegistration {
        return .init { cell, _, item in
            guard case let .productItem(product) = item else { return }
            cell.contentConfiguration = ProductContentConfiguration(product: product)
        }
    }
    
    func makeFavouriteCellRegistration() -> CellRegistration {
        return .init { cell, _, item in
            guard case let .favouriteItem(favourite) = item else { return }
            cell.contentConfiguration = FavouriteContentConfiguration(favourite: favourite)
        }
    }
    
    func makeBannerCellRegistration() -> CellRegistration {
        return .init { cell, _, item in
            guard case let .bannerItem(banner) = item else { return }
            cell.contentConfiguration = BannerContentConfiguration(banner: banner)
        }
    }
    
    func makeTitleHeaderRegistration() -> UICollectionView.SupplementaryRegistration<TitleHeaderView> {
        return .init(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] headerView, _, indexPath in
            guard let self else { return }
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            guard let title = section.title else { return }
            headerView.configure(with: title)
        }
    }
    
    func makePageControlFooterRegistration() -> UICollectionView.SupplementaryRegistration<PageControlFooterView> {
        return .init(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] footerView, _, indexPath in
            guard let self else { return }
            
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            guard section == .banner else { return }
            
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: section)
            footerView.configure(numberOfPages: items.count)
        }
    }
}
