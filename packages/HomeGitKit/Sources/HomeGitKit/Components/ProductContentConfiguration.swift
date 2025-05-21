import UIKit
import CoreKit
import GlobalEntities

struct ProductContentConfiguration: UIContentConfiguration, Equatable {
    fileprivate let product: ProductModel
    
    init(product: ProductModel) {
        self.product = product
    }
    
    func makeContentView() -> UIView & UIContentView {
        return ProductContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> ProductContentConfiguration {
        return self
    }
}

private class ProductContentView: UIView, UIContentView {
    // Properties
    var configuration: UIContentConfiguration {
        didSet {
            self.applyConfigure(configuration: configuration)
        }
    }
    
    // Declare UI
    private lazy var iconImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.tintColor = .systemGray3
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // Initial
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupUI()
        applyConfigure(configuration: configuration)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup
    private func setupUI() {
        appAddSubviews(views: iconImageView, titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: .getSpacing(.small)),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 56),
            iconImageView.heightAnchor.constraint(equalToConstant: 56),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .getSpacing(.xsmall)),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .getSpacing(.small)),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.getSpacing(.small)),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.getSpacing(.small))
        ])
    }
    
    private func applyConfigure(configuration: UIContentConfiguration) {
        guard let config = configuration as? ProductContentConfiguration else { return }
        
        // Apply configuration properties
        titleLabel.text = config.product.title
        iconImageView.image = UIImage(named: config.product.icon)
    }
}
