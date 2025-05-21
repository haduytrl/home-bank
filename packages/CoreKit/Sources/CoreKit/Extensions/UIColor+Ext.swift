import UIKit

public extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: a
        )
    }
    
    static var gray8:          UIColor { .init(r: 68,  g: 68,  b: 68) }
    static var gray6:          UIColor { .init(r: 111,  g: 111,  b: 111) }
    static var gray7:          UIColor { .init(r: 85,  g: 85,  b: 85) }
    static var gray5:          UIColor { .init(r: 136, g: 136, b: 136) }
    static var battleShipGrey: UIColor { .init(r: 115,  g: 116,  b: 126) }
    static var orange1:        UIColor { .init(r: 255, g: 136, b: 97) }
}
