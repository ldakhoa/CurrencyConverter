import Foundation

/// An object that manages the weather data and apply business rules to achive a use case.
///
/// The use cases situated on top of models and the “ports” for the data access layer (used for dependency inversion, usually Repository interfaces), retrieve and store domain models by using either repositories or other use cases.
protocol CurrencyConverterUseCase {
    /// Get the latest exchange rates available from the Open Exchange Rates API.
    func exchangeRate() async throws -> ExchangeRateResponse
}

/// An object that manages the weather data and apply business rules to achive a use case.
struct DefaultCurrencyConverterUseCase: CurrencyConverterUseCase {
    // MARK: Dependencies

    /// An object provides methods for interacting with the exchange currency data in the remote database.
    private let remoteCurrencyConverterRepository: RemoteCurrencyConverterRepository

    // MARK: Init

    /// Initiate an object that manages the weather data and apply business rules to achive a use case.
    /// - Parameter remoteCurrencyConverterRepository: An object provides methods for interacting with the exchange currency data in the remote database.
    init(remoteCurrencyConverterRepository: RemoteCurrencyConverterRepository = DefaultRemoteCurrencyConverterRepository()) {
        self.remoteCurrencyConverterRepository = remoteCurrencyConverterRepository
    }

    // MARK: CurrencyConverterUseCase

    func exchangeRate() async throws -> ExchangeRateResponse {
        try await remoteCurrencyConverterRepository.exchangeRate()
    }
}
