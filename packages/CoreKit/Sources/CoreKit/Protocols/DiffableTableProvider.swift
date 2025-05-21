import Foundation
import UIKit

public protocol DiffableTableProvider {
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    
    func makeDataSource(for tableView: UITableView) -> DataSource
}
