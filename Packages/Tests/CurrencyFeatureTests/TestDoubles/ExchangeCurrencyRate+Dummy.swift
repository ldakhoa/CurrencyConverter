import Foundation
@testable import CurrencyFeature

// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
extension ExchangeCurrencyRate {
    static var dummy: Self {
        /// A dummy value
        let data = "{\"name\":\"Afghan Afghani\",\"symbol\":\"AFN\",\"rate\":69.193188}".data(using: .utf8)!
        let decoder = JSONDecoder()
        let result = try! decoder.decode(Self.self, from: data)
        return result
    }
}
// swiftlint:enable force_try
// swiftlint:enable force_unwrapping
