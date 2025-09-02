import WidgetKit
import SwiftUI

struct AppMediumWidgetEntryView : View {
    var entry: MediumWidgetProvider.Entry

    var body: some View {
        VStack(spacing: 8) {
            Text(entry.item)
            VStack {
                Text(entry.date, style: .date)
                    .italic()
                Text(entry.date, style: .time)
                    .bold()
            }
        }
        .background(Color.white)
    }
}

public struct AppMediumWidget: Widget {
    let kind: String = String(describing: AppMediumWidget.self)
    
    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MediumWidgetProvider()) { entry in
            AppMediumWidgetEntryView(entry: entry)
                .padding()
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("My Medium Widget")
        .description("This is an medium widget")
    }
    
    public func forPreviewOnly() -> some View {
        AppMediumWidgetEntryView(entry: .init(date: Date(), item: "This is my widget bank"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName(kind)
    }
}

#Preview("\(String(describing: AppMediumWidget.self)) in backdrop") {
    ZStackGradientWrapperView {
        AppMediumWidgetEntryView(entry: .init(date: Date(), item: "This is my widget bank"))
            .frame(width: WidgetHelper.mediumSize.width, height: WidgetHelper.mediumSize.height)
            .background(Color.white) // or Color.white
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(radius: 16, y: 8)
    }
}
