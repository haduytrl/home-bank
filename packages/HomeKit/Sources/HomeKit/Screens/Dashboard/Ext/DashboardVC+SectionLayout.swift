import UIKit

extension DashboardViewController {
    func createProfileSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .getSpacing(.medium),
            leading: .getSpacing(.xlarge),
            bottom: 0,
            trailing: .getSpacing(.xlarge)
        )
        return section
    }
    
    func createBalanceSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .getSpacing(.xmedium),
            leading: .getSpacing(.xlarge),
            bottom: 0,
            trailing: .getSpacing(.xlarge)
        )
        return section
    }
    
    func createProductsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .estimated(96.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(96.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .getSpacing(.xmedium), leading: 0,
            bottom: .getSpacing(.large) + 2, trailing: 0)
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    
    func createFavouriteSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: .getSpacing(.xsmall),
            leading: .getSpacing(.xsmall),
            bottom: .getSpacing(.xsmall),
            trailing: .getSpacing(.xsmall)
        )
        
        var groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(76.0),
            heightDimension: .absolute(88.0))
        
        if isEmpty {
            groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.85),
                heightDimension: .estimated(60.0))
        }
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        if isEmpty {
            group.contentInsets = .init(top: 0, leading: .getSpacing(.xmedium), bottom: 0, trailing: 0)
        }
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .getSpacing(.xmedium)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .getSpacing(.xmedium),
            leading: .getSpacing(.xlarge),
            bottom: .getSpacing(.medium),
            trailing: .getSpacing(.xlarge)
        )
        section.orthogonalScrollingBehavior = .continuous
        
        // Add header for favorite section
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(.getSpacing(.xlarge)))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        if #available(iOS 16.0, *) {
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .getSpacing(.xlarge), bottom: 0, trailing: .getSpacing(.xlarge))
        } else {
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: .getSpacing(.xlarge) * 2)
        }
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.26))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: .getSpacing(.xlarge),
            bottom: .getSpacing(.xssmall),
            trailing: .getSpacing(.xlarge)
        )
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        // Add page control
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(20))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [footer]
        
        // — Page update handler
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, env in
            guard let self else { return }
            let groupWidth = env.container.effectiveContentSize.width
            let pageNo = Int(round(contentOffset.x / groupWidth))
            pageControlFooterView?.updateCurrentPage(pageNo)
        }
        
        return section
    }
}
