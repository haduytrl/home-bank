import UIKit
import CoreKit
import GlobalEntities

struct BannerContentConfiguration: UIContentConfiguration, Equatable {
    fileprivate let banner: BannerModel
    
    public init(banner: BannerModel) {
        self.banner = banner
    }
    
    func makeContentView() -> UIView & UIContentView {
        return BannerContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> BannerContentConfiguration {
        return self
    }
}

private class BannerContentView: UIView, UIContentView {
    private let bannerImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        v.layer.cornerRadius = .getCornerRadius(.md)
        v.backgroundColor = .systemGray4
        v.translatesAutoresizingMaskIntoConstraints = false
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
        appAddSubviews(views: bannerImageView)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func applyConfigure(configuration: UIContentConfiguration) {
        guard let config = configuration as? BannerContentConfiguration else { return }
        
        // Apply configuration properties

        bannerImageView.backgroundColor = .systemGray5
        bannerImageView.setCachedImage(from: URL(string: config.banner.url))
    }
}
