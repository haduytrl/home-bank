import SwiftUI
import CoreKit

struct ZStackGradientWrapperView<T: View>: View {
    private let content: T

    init(@ViewBuilder content: () -> T) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Big backdrop
            LinearGradient(
                gradient: Gradient(colors: [Color(UIColor.orange1), Color(UIColor.gray5).opacity(0.4)]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Centered widget content
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    ZStackGradientWrapperView {
        Text("Hello world")
            .foregroundColor(.black.opacity(0.65))
            .bold()
    }
}
