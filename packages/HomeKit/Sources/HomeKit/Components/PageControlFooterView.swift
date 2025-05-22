import UIKit

class PageControlFooterView: UICollectionReusableView {
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .systemGray5
        control.currentPageIndicatorTintColor = .black.withAlphaComponent(0.6)
        control.isUserInteractionEnabled = false
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        appAddSubviews(views: pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: topAnchor),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Configure

extension PageControlFooterView {
    func configure(numberOfPages: Int, currentPage: Int = 0) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
    }
    
    func updateCurrentPage(_ currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}
