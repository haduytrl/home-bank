import WidgetKit
import SwiftUI

struct AppSmallWidgetEntryView : View {
    var entry: SmallWidgetProvider.Entry

    var body: some View {
        VStack {
            Text(entry.item)
        }
        .background(Color.white)
    }
}

public struct AppSmallWidget: Widget {
    let kind: String = String(describing: AppSmallWidget.self)
    
    public init() {}

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SmallWidgetProvider()) { entry in
            AppSmallWidgetEntryView(entry: entry)
                .padding()
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("My Small Widget")
        .description("This is an small widget")
    }
    
    public func forPreviewOnly() -> some View {
        AppSmallWidgetEntryView(entry: .init(item: "My Home Bank"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName(kind)
    }
}

#Preview("\(String(describing: AppSmallWidget.self)) in backdrop") {
    ZStackGradientWrapperView {
        AppSmallWidgetEntryView(entry: .init(item: "My Home Bank"))
            .frame(width: WidgetHelper.smallSize.width, height: WidgetHelper.smallSize.height)
            .background(Color.white) // or Color.white
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(radius: 16, y: 8)
    }
}
