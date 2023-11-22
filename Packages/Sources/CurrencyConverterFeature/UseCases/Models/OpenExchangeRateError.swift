import Foundation

/// An object abstracts the error returned from the OpenWeatherMaps API.
struct OpenExchangeRateError: LocalizedError, Codable, Equatable {
    /// A message that describes why the error did occur.
    let message: String
    
    // MARK: LocalizedError
    
    var errorDescription: String? { message }
}
