import WidgetKit

protocol CommonWidgetEntry: TimelineEntry {
    associatedtype Item
    var item: Item { get }
}
