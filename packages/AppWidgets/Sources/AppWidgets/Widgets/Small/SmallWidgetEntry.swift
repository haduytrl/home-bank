import WidgetKit
import Foundation

struct SmallWidgetEntry: CommonWidgetEntry {
    typealias Item = String
    
    let date: Date = Date()
    let item: String
    
    init(item: String) {
        self.item = item
    }
}
