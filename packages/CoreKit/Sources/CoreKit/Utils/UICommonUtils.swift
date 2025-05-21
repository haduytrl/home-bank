import UIKit

public enum UICommonUtils {
    public static func animated(
        duration: CGFloat = 0.25,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }
    
    public static func transition(
        _ view: UIView,
        duration: CGFloat = 0.25,
        animations: (() -> Void)? = nil
    ) {
        UIView.transition(with: view, duration: duration, options: .transitionCrossDissolve, animations: animations, completion: nil)
    }
}
