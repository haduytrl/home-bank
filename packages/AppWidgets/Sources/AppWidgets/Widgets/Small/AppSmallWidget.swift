import WidgetKit
import SwiftUI
import CoreKit

struct AppSmallWidgetEntryView : View {
    var entry: SmallWidgetProvider.Entry
    
    var body: some View {
        GeometryReader { proxy in
            let cardWidth = proxy.size.width * 0.82
            let cardHeight = proxy.size.height * 0.65
            
            VStack(spacing: 4) {
                // Box
                VStack(spacing: 4) {
                    Text("BANK")
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(Color.gray.opacity(0.8))
                        .padding(.top, 4)
                    
                    // Safely unwrap the Base64 image
                    if let qr = Image(base64String: entry.item) {
                        qr
                            .interpolation(.none)
                            .resizable()
                            .frame(width: cardWidth - 8)
                            .padding(.bottom, 4)
                    } else {
                        // Fallback if the base64 is invalid
                        Image(systemName: "qrcode")
                            .font(.system(size: 30, weight: .regular))
                            .foregroundColor(.gray.opacity(0.8))
                            .frame(width: cardWidth - 8)
                    }
                }
                .frame(width: cardWidth, height: cardHeight)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                
                // Info
                VStack(spacing: 2) {
                    Text("nguyen ha duy".uppercased())
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color.black.opacity(0.8))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    Text("1407199777")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .padding(.horizontal, 6)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 12)
            .padding(.bottom, 7)
            .background(LinearGradient(
                gradient: Gradient(colors: [Color(UIColor.green), Color(UIColor.gray5).opacity(0.4)]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
        }
    }
}

public struct AppSmallWidget: Widget {
    let kind: String = String(describing: Self.self)
    
    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SmallWidgetProvider()) { entry in
            AppSmallWidgetEntryView(entry: entry)
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

//#Preview("\(String(describing: AppSmallWidget.self)) in backdrop") {
//    ZStackGradientWrapperView {
//        AppSmallWidgetEntryView(entry: .init(item: "My Home Bank"))
//            .frame(width: WidgetHelper.smallSize.width, height: WidgetHelper.smallSize.height)
//            .background(Color.white) // or Color.white
//            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
//            .shadow(radius: 16, y: 8)
//    }
//}
