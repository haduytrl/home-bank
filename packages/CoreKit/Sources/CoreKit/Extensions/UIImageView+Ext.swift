import UIKit

public extension UIImageView {
    func setCachedImage(from url: URL?, placeholder: UIImage? = nil) {
        if let placeholder { self.image = placeholder }
        guard let url = url else { return }
        
        let cacheKey = NSString(string: url.absoluteString)
        
        // If cached, short-circuit
        if let cached = ImageCache.shared.object(forKey: cacheKey) {
            self.image = cached
            return
        }
        
        // Otherwise fetch in a Task
        Task.detached(priority: .utility) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let img = UIImage(data: data) else { return }
                
                ImageCache.shared.setObject(img, forKey: cacheKey)
                await MainActor.run {
                    self.image = img
                }
            } catch {
                #if DEBUG
                debugPrint(error.localizedDescription)
                #endif
            }
        }
    }
}
