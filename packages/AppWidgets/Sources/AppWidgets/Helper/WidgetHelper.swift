import Foundation
import SwiftUI

enum WidgetHelper {
    static let smallSize: CGSize   = .init(width: 170, height: 170)
    static let mediumSize: CGSize  = .init(width: 364, height: 170)
    static let largeSize: CGSize   = .init(width: 364, height: 382)
    
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
//        let transform = CGAffineTransform(scaleX: 12, y: 12)

        guard let output = filter.outputImage else {
            return nil
        }
        return UIImage(ciImage: output)
    }
}

extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String),
              let uiImage = UIImage(data: data)
        else { return nil }
        
        self = Image(uiImage: uiImage)
    }
}
