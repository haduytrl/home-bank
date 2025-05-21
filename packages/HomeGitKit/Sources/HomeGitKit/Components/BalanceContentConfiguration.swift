import UIKit
import CoreKit

struct BalanceContentConfiguration: UIContentConfiguration, Equatable {
    fileprivate let usdBalance: Double
    fileprivate let khrBalance: Double
    
    init(usdBalance: Double, khrBalance: Double) {
        self.usdBalance = usdBalance
        self.khrBalance = khrBalance
    }
    
    func makeContentView() -> UIView & UIContentView {
        return BalanceContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> BalanceContentConfiguration {
        return self
    }
}

private class BalanceContentView: UIView, UIContentView {
    // Properties
    private let asteriskText = "********"
    private var usdBalance: String = "0.0"
    private var khrBalance: String = "0.0"
    private var showEye: Bool = false {
        didSet {
            guard oldValue != showEye else { return }
            balanceEyeButton.setImage(UIImage(systemName: showEye ? "eye" : "eye.slash"), for: .normal)
            handleOnOffBalance()
        }
    }
    var configuration: UIContentConfiguration {
        didSet {
            self.applyConfigure(configuration: configuration)
        }
    }
    
    // Declare UI
    private lazy var usdBalanceLabel = makeLabel(with: asteriskText, size: .getSpacing(.xlarge), weight: .medium)
    private lazy var khrBalanceLabel = makeLabel(with: asteriskText, size: .getSpacing(.xlarge), weight: .medium)
    private lazy var balanceEyeButton = makeEyeButton()
    
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
        // Header
        let headerTitle = makeLabel(with: "My Account Balance", color: .gray5, size: 18, weight: .heavy)
        let headerStack = makeHorizontalStack(views: headerTitle, balanceEyeButton)
        
        // USD Balance
        let usdTitle = makeLabel(with: "USD", color: .label.withAlphaComponent(0.6), size: 16)
        let usdStack = makeVerticalStack(views: usdTitle, usdBalanceLabel)
        
        // KHR Balance
        let khrTitle = makeLabel(with: "KHR", color: .label.withAlphaComponent(0.6), size: 16)
        let khrStack = makeVerticalStack(views: khrTitle, khrBalanceLabel)
        
        appAddSubviews(views: headerStack, usdStack, khrStack)
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            balanceEyeButton.widthAnchor.constraint(equalToConstant: .getSpacing(.xlarge)),
            balanceEyeButton.heightAnchor.constraint(equalToConstant: .getSpacing(.xlarge)),
            
            usdStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: .getSpacing(.medium)),
            usdStack.leadingAnchor.constraint(equalTo: headerStack.leadingAnchor),
            usdStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            khrStack.topAnchor.constraint(equalTo: usdStack.bottomAnchor, constant: .getSpacing(.medium)),
            khrStack.leadingAnchor.constraint(equalTo: headerStack.leadingAnchor),
            khrStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            khrStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func applyConfigure(configuration: UIContentConfiguration) {
        guard let config = configuration as? BalanceContentConfiguration else { return }
        
        // Apply configuration properties
        usdBalance = config.usdBalance.formatCurrency
        khrBalance = config.khrBalance.formatCurrency
    }
}

// MARK: - Configure

extension BalanceContentView {
    private func handleOnOffBalance() {
        let labels: [UILabel: String] = [
            usdBalanceLabel: usdBalance,
            khrBalanceLabel: khrBalance
        ]
        
        labels.forEach { label, value in
            UICommonUtils.transition(label) { [weak self] in
                guard let self else { return }
                label.text = !showEye ? asteriskText : value
            }
        }
    }
}

// MARK: - Making UI

private extension BalanceContentView {
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
    
    func makeHorizontalStack(views: UIView...) -> UIStackView {
        let v = UIStackView(arrangedSubviews: views)
        v.axis = .horizontal
        v.spacing = .getSpacing(.xssmall)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    func makeVerticalStack(views: UIView...) -> UIStackView {
        let v = UIStackView(arrangedSubviews: views)
        v.axis = .vertical
        v.spacing = .getSpacing(.small)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    func makeEyeButton() -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        btn.tintColor = .orange1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addAction(UIAction(handler: { [weak self] _ in
            self?.showEye.toggle()
        }), for: .touchUpInside)
        return btn
    }
}
