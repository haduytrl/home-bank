import UIKit
import HomeKit

class MainTabBarViewController: UITabBarController {
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        setViewControllers(viewControllers, animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarUI()
    }
}

// MARK: Setup

private extension MainTabBarViewController {
    func setUpTabBarUI() {
        let layer = CAShapeLayer()
        let x: CGFloat = .getSpacing(.medium) - 2
        let y: CGFloat = .zero
        let width = self.tabBar.bounds.width - x * 2
        let height = 54.0 // design height
        
        layer.fillColor = UIColor.white.cgColor
        layer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                      y: self.tabBar.bounds.minY - y,
                                                      width: width,
                                                      height: height),
                                  cornerRadius: height / 2).cgPath
        
        // tab bar shadow
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = .getCornerRadius(.sm)
        
        // add tab bar layer
        self.tabBar.layer.insertSublayer(layer, at: .zero)
        
        // fix items positioning
        self.tabBar.itemWidth = width / CGFloat(self.viewControllers?.count ?? 0)
        self.tabBar.itemPositioning = .centered
        self.tabBar.unselectedItemTintColor = .gray7
        self.tabBar.tintColor = .orange1
        
        // make the bar fully transparent
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
    }
}
