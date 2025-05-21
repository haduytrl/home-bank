import UIKit
import CoreKit
import GlobalEntities

struct FavouriteContentConfiguration: UIContentConfiguration, Equatable {
    fileprivate let favourite: FavouriteModel
    
    init(favourite: FavouriteModel) {
        self.favourite = favourite
    }
    
    func makeContentView() -> UIView & UIContentView {
        return FavouriteContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> FavouriteContentConfiguration {
        return self
    }
}

private class FavouriteContentView: UIView, UIContentView {
    // Properties
    var configuration: UIContentConfiguration {
        didSet {
            self.applyConfigure(configuration: configuration)
        }
    }
    
    // Declare UI
    private let iconImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .center
        v.backgroundColor = .systemGray5
        v.layer.cornerRadius = 56 / 2
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = . gray6
        lbl.font = .systemFont(ofSize: 12)
        lbl.textAlignment = .center
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
        appAddSubviews(views: iconImageView, nameLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 56),
            iconImageView.heightAnchor.constraint(equalToConstant: 56),
            
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .getSpacing(.xsmall)),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .getSpacing(.xmedium)),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.getSpacing(.xmedium)),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.getSpacing(.small))
        ])
    }
    
    private func applyConfigure(configuration: UIContentConfiguration) {
        guard let config = configuration as? FavouriteContentConfiguration else { return }
        
        // Apply configuration properties
        nameLabel.text = config.favourite.username
        
        // Set icon based on transfer type
        iconImageView.image = UIImage(named: config.favourite.transType.icon)
    }
}

