import WidgetKit

struct MediumWidgetProvider: TimelineProvider {
    typealias Entry = MediumWidgetEntry
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), item: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = Entry(date: Date(), item: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [Entry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = Entry(date: entryDate, item: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
