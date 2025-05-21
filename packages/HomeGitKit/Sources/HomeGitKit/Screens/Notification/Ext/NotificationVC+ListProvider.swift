import UIKit
import CoreKit
import GlobalEntities

extension NotificationViewController: DiffableTableProvider {
    typealias ViewModel = NotificationViewModel
    typealias Section = ViewModel.Section
    typealias Item = ViewModel.Item
    
    func makeDataSource(for tableView: UITableView) -> DataSource {
        return DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            
            switch item {
            case let .notification(data):
                let notificationCell = NotificationContentConfiguration(item: data)
                cell.contentConfiguration = notificationCell
                return cell
            }
        }
    }
    
    func makeSnapshotOfNotifications(_ datas: [NotificationModel]) -> Snapshot {
        var snapshot = Snapshot()
        let items = datas.map { ViewModel.Item.notification($0) }
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        return snapshot
    }
}
