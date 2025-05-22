import UIKit
import Combine
import CoreKit
import GlobalEntities

class AccountViewController: BaseViewController<AccountViewModel> {
    // MARK: Declare UI
    
    private lazy var emptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black.withAlphaComponent(0.5)
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.text = "Account will be implemented soon"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Setup
    
    override func setupUI() {
        super.setupUI()
        
        view.appAddSubviews(views: emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func setupBindViewModel() {

    }
}
