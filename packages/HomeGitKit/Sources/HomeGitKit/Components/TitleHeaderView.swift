import UIKit

class TitleHeaderView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray5
        lbl.font = .systemFont(ofSize: 18, weight: .heavy)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let moreButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("More", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.setTitleColor(.gray7, for: .normal)
        
        btn.imageView?.tintColor = .gray5
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.imageEdgeInsets = .init(top: 0, left: .getSpacing(.small), bottom: 0, right: -.getSpacing(.small))
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        appAddSubviews(views: titleLabel, moreButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: .getSpacing(.xmedium)),
            
            moreButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
