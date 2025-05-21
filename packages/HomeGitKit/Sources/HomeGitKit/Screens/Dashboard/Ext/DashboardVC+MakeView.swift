import UIKit

extension DashboardViewController {
    func makeCollectionView(didPullToRefresh: Selector) -> UICollectionView {
        let v = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        v.backgroundColor = .clear
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.showsVerticalScrollIndicator = false
        v.alwaysBounceVertical = true
        v.translatesAutoresizingMaskIntoConstraints = false
        
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
