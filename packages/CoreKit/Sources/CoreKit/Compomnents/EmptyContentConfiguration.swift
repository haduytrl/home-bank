import UIKit

public struct EmptyContentConfiguration: UIContentConfiguration {
    fileprivate let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public func makeContentView() -> UIView & UIContentView {
        return EmptyContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> EmptyContentConfiguration {
        return self
    }
}

public class EmptyContentView: UIView, UIContentView {
    private lazy var iconView: UIImageView = makeImageView()
    private lazy var messageLabel: UILabel = makeLabel()
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupUI()
        applyConfigure(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var configuration: UIContentConfiguration {
        didSet {
            self.applyConfigure(configuration: configuration)
        }
    }
    
    private func setupUI() {
        appAddSubviews(views: iconView, messageLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 56),
            iconView.heightAnchor.constraint(equalToConstant: 56),
            iconView.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: .getSpacing(.xmedium)),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func applyConfigure(configuration: UIContentConfiguration) {
        guard let config = configuration as? EmptyContentConfiguration else { return }
        
        // Apply configuration properties
        messageLabel.text = config.message
    }
}

// MARK: - Making UI

private extension EmptyContentView {
    func makeLabel() -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .gray6
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
    func makeImageView() -> UIImageView {
        let v = UIImageView()
        v.image = UIImage(named: "iconUserEmpty")
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .systemGray4
        v.layer.cornerRadius = 56 / 2
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
}

