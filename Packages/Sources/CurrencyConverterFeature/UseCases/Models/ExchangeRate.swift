import Foundation

/// An object abstracts the latest exchange rate received from the Open Exchange Rates API.
struct ExchangeRateResponse: Codable {
    /// A disclaimer stating the terms and conditions of using the exchange rate data.
    let disclaimer: String

    /// The license or attribution information for the exchange rate data.
    let license: String

    /// The timestamp indicating when the exchange rate data was obtained.
    let timestamp: Int

    /// The base currency against which the exchange rates are provided.
    let base: String

    /// The exchange rates for different currencies against the base currency.
    let rates: [String: Double]
}
