import Foundation

struct FixDepositedResponse: Decodable {
    let fixedDepositList: [AccountResponse]
}
