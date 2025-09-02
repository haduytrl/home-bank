import WidgetKit
import SwiftUI
import AppWidgets

@main
struct homebankWidgetBundle: WidgetBundle {
    var body: some Widget {
        AppSmallWidget()
        AppMediumWidget()
    }
}

struct AppWidgets_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppSmallWidget().forPreviewOnly()
            AppMediumWidget().forPreviewOnly()
        }
    }
}
