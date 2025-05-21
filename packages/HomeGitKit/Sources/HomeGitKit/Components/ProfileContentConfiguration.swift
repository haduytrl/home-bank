import UIKit
import CoreKit

struct ProfileContentConfiguration: UIContentConfiguration {
    fileprivate let hasNotifications: Bool
    var notificationAction: (() -> Void)? = nil
    
    init(hasNotifications: Bool) {
        self.hasNotifications = hasNotifications
    }
    
    func makeContentView() -> UIView & UIContentView {
        return ProfileContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> ProfileContentConfiguration {
        return self
    }
}

private class ProfileContentView: UIView, UIContentView {
    private lazy var profileImageView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "avatar")
        v.tintColor = .black
        v.layer.cornerRadius = (.getSpacing(.extraLarge1) - 4) / 2
        v.tintColor = .systemGray3
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var dotView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemRed
        v.layer.cornerRadius = .getCornerRadius(.xs)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()
    
    private lazy var notificationButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "bell"), for: .normal)
        v.tintColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addAction(UIAction(handler: { [weak self] _ in
            self?.notificationTapped()
        }), for: .touchUpInside)
        return v
    }()
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupUI()
        applyConfigure(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            self.applyConfigure(configuration: configuration)
        }
    }
    
    private func setupUI() {
        appAddSubviews(views: profileImageView, notificationButton, dotView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: .getSpacing(.extraLarge1) + 4),
            profileImageView.heightAnchor.constraint(equalToConstant: .getSpacing(.extraLarge1) + 4),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            notificationButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            notificationButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: .getSpacing(.xlarge)),
            notificationButton.heightAnchor.constraint(equalToConstant: .getSpacing(.xlarge)),
            
            dotView.centerXAnchor.constraint(equalTo: notificationButton.centerXAnchor, constant: .getSpacing(.xsmall)),
            dotView.centerYAnchor.constraint(equalTo: notificationButton.centerYAnchor, constant: -.getSpacing(.xsmall)),
            dotView.widthAnchor.constraint(equalToConstant: .getSpacing(.small) - 1),
            dotView.heightAnchor.constraint(equalToConstant: .getSpacing(.small) - 1)
        ])
    }
    
    private func applyConfigure(configuration: UIContentConfiguration) {
        guard let config = configuration as? ProfileContentConfiguration else { return }
        
        // Apply configuration properties
        dotView.isHidden = !config.hasNotifications
    }
    
    private func notificationTapped() {
        guard let config = configuration as? ProfileContentConfiguration else { return }
        config.notificationAction?()
    }
}
