import Foundation

public struct FavouriteModel: Hashable {
    private let uuid: String
    public let username: String
    public let transType: TransferType
    
    public init(username: String, transType: TransferType) {
        self.uuid = UUID().uuidString
        self.username = username
        self.transType = transType
    }
}

public extension FavouriteModel {
    enum TransferType: String {
        case cubc = "CUBC"
        case mobile = "Mobile"
        case pmf = "PMF"
        case creditCard = "CreditCard"
        case unknown
        
        public var icon: String {
            let dict: [Self: String] = [
                .cubc: "iconCUBC",
                .creditCard: "iconCreditCard",
                .mobile: "iconMobile",
                .pmf: "iconPMF"
            ]
            
            return dict[self] ?? "iconCUBC"
        }
    }
}
