import Foundation

typealias ExchangeCurrencyResponse = [String: String]

struct ExchangeCurrency: Codable, Hashable {
    let name: String
    let symbol: String
}
