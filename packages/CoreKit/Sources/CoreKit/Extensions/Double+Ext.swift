import UIKit

public extension Double {
    var formatCurrency: String {
        let formatter = NumberFormatter()
        formatter.locale                 = Locale(identifier: "en_US")  // Guarantee . and ,
        formatter.numberStyle           = .decimal
        formatter.groupingSeparator     = ","
        formatter.decimalSeparator      = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
