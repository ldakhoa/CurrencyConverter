import Foundation

struct ExchangeCurrencyRate: Codable, Hashable {
    let name: String
    let symbol: String
    let rate: Double
}
