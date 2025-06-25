import UIKit

extension DashboardViewController {
    func makeCollectionView(didPullToRefresh: Selector) -> UICollectionView {
        let v = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        v.backgroundColor = .clear
        v.showsVerticalScrollIndicator = false
        v.contentInset.bottom = .getSpacing(.mediumLarge)
        
        let offset: CGFloat = -20
        let rc = UIRefreshControl()
        rc.bounds = CGRect(x: rc.bounds.minX, y: offset, width: rc.bounds.width, height: rc.bounds.height)
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
