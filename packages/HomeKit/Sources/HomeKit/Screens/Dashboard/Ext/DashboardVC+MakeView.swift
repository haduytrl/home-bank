import UIKit

extension DashboardViewController {
    func makeCollectionView(didPullToRefresh: Selector) -> UICollectionView {
        let v = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        v.backgroundColor = .clear
        v.showsVerticalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentInset.bottom = .getSpacing(.mediumLarge)
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: didPullToRefresh, for: .valueChanged)
        v.refreshControl = rc
        return v
    }
    
    func makePanGesture(action: Selector) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer(target: self,action: action)
        pan.delegate = self
        return pan
    }
}

