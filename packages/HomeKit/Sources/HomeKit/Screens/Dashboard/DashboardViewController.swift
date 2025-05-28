import UIKit
import Combine
import CoreKit
import GlobalEntities

class DashboardViewController: BaseViewController<DashboardViewModel> {
    // MARK: Properties
    
    private(set) lazy var dataSource: DataSource = makeDataSource(for: collectionView)
    private var bannerTimer: Timer?
    private var isUserInteracting: Bool = false
    private lazy var pan: UIPanGestureRecognizer = makePanGesture(action: #selector(handlePan(_:)))
    
    // MARK: Declare UI
    
    private lazy var collectionView = makeCollectionView(didPullToRefresh: #selector(didPullToRefresh))
    weak var pageControlFooterView: PageControlFooterView?
    
    // MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.firstLoadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopBannerTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard dataSource.snapshot().numberOfItems(inSection: .banner) > 0 else { return }
        startBannerTimer()
    }
    
    deinit {
        stopBannerTimer()
    }
    
    // MARK: Setup
    
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .white
        
        // Add collection view to view hierarchy
        view.addSubview(collectionView)
        collectionView.addGestureRecognizer(pan)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func setupBindViewModel() {
        cancellables = []
        
        // Bind error messages
        makeErrorMessageSubscription()
        
        // Bind sections and data
        makeSectionsSubscription()
        makeBalanceSubscription()
        makeProductsSubscription()
        makeFavoritesSubscription()
        makeBannersSubscription()
    }
}

// MARK: - Make subscription

private extension DashboardViewController {
    func makeSectionsSubscription() {
        viewModel.$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                guard let self else { return }
                applySectionsSnapshot(with: sections)
                
                // make default snapshots (cells)
                makeSnapshotOfProfile(hasNotification: false)
                makeSnapshotOfFavorites([])
            }.store(in: &cancellables)
    }
    
    func makeBalanceSubscription() {
        Publishers.Zip(viewModel.$usdBalance, viewModel.$khrBalance)
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] usd, khr in
                self?.makeSnapshotOfBalance(usd: usd, khr: khr)
            }
            .store(in: &cancellables)
    }
    
    func makeProductsSubscription() {
        viewModel.$products
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.makeSnapshotOfProducts(products)
            }
            .store(in: &cancellables)
    }
    
    func makeFavoritesSubscription() {
        viewModel.$favourites
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                self?.makeSnapshotOfFavorites(favorites)
            }
            .store(in: &cancellables)
    }
    
    func makeBannersSubscription() {
        let bannersSubscription = viewModel.$banners
            .dropFirst()
            .share()
            .receive(on: DispatchQueue.main)
        
        bannersSubscription
            .sink { [weak self] banners in
                self?.makeSnapshotOfBanners(banners)
            }
            .store(in: &cancellables)
        
        bannersSubscription
            .first()
            .filter { !$0.isEmpty }
            .sink { [weak self] _ in
                self?.startBannerTimer()
            }
            .store(in: &cancellables)
    }
    
    func makeErrorMessageSubscription() {
        viewModel.$errorMessage
            .dropFirst()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message: message)
            }.store(in: &cancellables)
    }
}

// MARK: - Configure

private extension DashboardViewController {
    // start auto-swipe
    func startBannerTimer() {
        bannerTimer = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(autoSwipeBanner),
            userInfo: nil,
            repeats: true
        )
    }
    
    // stop auto-swipe
    func stopBannerTimer() {
        bannerTimer?.invalidate()
        bannerTimer = nil
    }
    
    // Handle auto swipe for banners
    @objc func autoSwipeBanner() {
        guard pageControlFooterView != nil, !isUserInteracting else { return }
        
        let snapshot = dataSource.snapshot()
        
        // Get index of banner section
        let bannerSection = snapshot.indexOfSection(.banner) ?? viewModel.sections.count - 1
        
        // Get all the indexPaths currently visible in that section
        let visibleBannerIP = collectionView.indexPathsForVisibleItems
            .filter { $0.section == bannerSection }
            .first
        
        // If there’s none visible, bail out
        guard let visibleBannerIP else { return }
        
        // Compute the next page, wrapping at the end
        let nextPage = (visibleBannerIP.item + 1) % snapshot.numberOfItems(inSection: .banner) // e.g 5 % 5 == 0 will reset to end
        let nextIndexPath = IndexPath(item: nextPage, section: bannerSection)
        
        // Scroll to it
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    // Did refresh
    @objc func didPullToRefresh() {
        viewModel.performRefresh { [unowned self] in
            collectionView.refreshControl?.endRefreshing()
            makeSnapshotOfProfile(hasNotification: true, isAnim: false)
        }
    }
    
    // Handle pan gesture horizontal swipe
    @objc func handlePan(_ pan: UIPanGestureRecognizer) {
        let vel = pan.velocity(in: collectionView)
        
        switch pan.state {
        case .began:
            // only treat it as “user interacting” if it’s a mainly horizontal swipe
            // stop auto-swipe when pan horizontal is began
            guard abs(vel.x) > abs(vel.y), !isUserInteracting else { return }
            isUserInteracting = true
            stopBannerTimer()
        case .ended, .cancelled, .failed:
            guard isUserInteracting else { return }
            isUserInteracting = false
            startBannerTimer()
        default:
            break
        }
    }
}

// MARK: - Pan Gesture

extension DashboardViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
