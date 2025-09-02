import UIKit
import CoreKit

extension NotificationViewController {
    func makeBackBtn(action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.tintColor = .black.withAlphaComponent(0.8)
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: .getSpacing(.xsmall))
        return btn
    }
    
    func makeTableView(didPullToRefresh: Selector) -> UITableView {
        let v = UITableView(frame: .zero, style: .grouped)
        if #available(iOS 15.0, *) {
            v.sectionHeaderTopPadding = .leastNonzeroMagnitude
        } else {}
        v.backgroundColor = .clear
        v.rowHeight = UITableView.automaticDimension
        v.contentInsetAdjustmentBehavior = .never
        v.separatorStyle = .none
        v.dataSource = dataSource
        v.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        v.delegate = self
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: didPullToRefresh, for: .valueChanged)
        v.refreshControl = rc
        return v
    }
    
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
}
