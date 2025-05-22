import UIKit
import Combine
import CoreKit
import GlobalEntities

class NotificationViewController: BaseViewController<NotificationViewModel> {
    // MARK: Properties
    
    private(set) var dataSource: DataSource!
    
    // MARK: Declare UI
    
    private lazy var backButton: UIButton = makeBackBtn(action: #selector(didTapBack))
    private lazy var emptyLabel: UILabel = makeLabel(with: "No data available", color: .black.withAlphaComponent(0.5), size: 18, weight: .bold)
    private lazy var tableView: UITableView = makeTableView(didPullToRefresh: #selector(didPullToRefresh))
    
    // MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.firstLoadData()
        dataSource = makeDataSource(for: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Setup
    
    override func setupUI() {
        super.setupUI()
        
        title = "Notification"
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        view.appAddSubviews(views: tableView, emptyLabel)
        emptyLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getSpacing(.xlarge)),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func setupBindViewModel() {
        cancellables = []
        
        makeNotificationsSubscription()
        makeErrorMessageSubscription()
    }
}

// MARK: - Make subscription

private extension NotificationViewController {
    func makeNotificationsSubscription() {
        viewModel.$notifications
            .dropFirst()
            .compactMap { [weak self] notifications -> Snapshot? in
                guard let self else { return .init() }
                return makeSnapshotOfNotifications(notifications)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                guard let self else { return }
                emptyLabel.isHidden = snapshot.numberOfItems > 0
                dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)
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

private extension NotificationViewController {
    // Did tap back
    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    // Did refresh
    @objc func didPullToRefresh() {
        viewModel.refreshData { [unowned self] in
            tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Table Configure

extension NotificationViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int)
    -> UIView? { return nil }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)
    -> CGFloat { return .zero }
}
