import UIKit
import CoreKit
import GlobalEntities

// MARK: – Configuration

struct NotificationContentConfiguration: UIContentConfiguration, Equatable {    
    fileprivate let item: NotificationModel
    
    public init(item: NotificationModel) {
        self.item = item
    }
    
    public func makeContentView() -> UIView & UIContentView {
        return NotificationContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> NotificationContentConfiguration {
        return self
    }
}

// MARK: – Content View

private class NotificationContentView: UIView, UIContentView {
    // Properties
    public var configuration: UIContentConfiguration {
        didSet {
            apply(configuration: configuration)
        }
    }
    
    // Declare UI
    private lazy var indicatorDotView: UIView = makeIndicatorDotView()
    private lazy var titleLabel: UILabel = makeLabel(color: .label, size: 18, weight: .bold)
    private lazy var dateLabel: UILabel = makeLabel(color: .label.withAlphaComponent(0.75), size: 14, weight: .regular)
    private lazy var messageLabel: UILabel = makeLabel(color: .battleShipGrey, size: 16, weight: .regular)
    
    // Initial
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        setupUI()
        apply(configuration: configuration)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup
    private func setupUI() {
        // Add subviews
        appAddSubviews(views: indicatorDotView, titleLabel, dateLabel, messageLabel)
        titleLabel.adjustsFontSizeToFitWidth = true
        dateLabel.adjustsFontSizeToFitWidth = true
        messageLabel.numberOfLines = 2
        
        // Constraints
        NSLayoutConstraint.activate([
            // indicator dot
            indicatorDotView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .getSpacing(.medium)),
            indicatorDotView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            indicatorDotView.widthAnchor.constraint(equalToConstant: .getSpacing(.xmedium)),
            indicatorDotView.heightAnchor.constraint(equalToConstant: .getSpacing(.xmedium)),
            
            // title
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .getSpacing(.medium)),
            titleLabel.leadingAnchor.constraint(equalTo: indicatorDotView.trailingAnchor, constant: .getSpacing(.small)),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.getSpacing(.medium)),
            
            // date
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .getSpacing(.xsmall)),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // message
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: .getSpacing(.small)),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.getSpacing(.medium))
        ])
    }
    
    // MARK: – Apply Config
    
    private func apply(configuration: UIContentConfiguration) {
        guard let config = configuration as? NotificationContentConfiguration else { return }
        let item = config.item
        
        // unread indicator
        indicatorDotView.backgroundColor = item.isRead ? .clear : .orange1
        
        // info
        titleLabel.text   = item.title
        dateLabel.text    = item.lastUpdated
        messageLabel.text = item.message
    }
}

// MARK: Making UI

private extension NotificationContentView {
    func makeLabel(
        with title: String = "",
        color: UIColor = .gray8,
        size: CGFloat,
        weight: UIFont.Weight = .thin
    ) -> UILabel {
        let lbl = UILabel()
        lbl.textColor = color
        lbl.font = .systemFont(ofSize: size, weight: .bold)
        lbl.text = title
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
    func makeIndicatorDotView() -> UIView {
        let v = UIView()
        v.layer.cornerRadius = (.getCornerRadius(.md) - 4) / 2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
}
