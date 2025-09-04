import WidgetKit

struct SmallWidgetProvider: TimelineProvider {
    typealias Entry = SmallWidgetEntry
    
    func placeholder(in context: Context) -> Entry {
        Entry(item: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(item: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [Entry(item: "")], policy: .never)
        completion(timeline)
    }
}
