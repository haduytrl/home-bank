import Foundation

public struct DataWrapperDTO<T: Decodable>: Decodable {
    public let msgCode: String?
    public let msgContent: String?
    public let result: T?
}
