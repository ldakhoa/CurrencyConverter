import Foundation

/// An object that manages the weather data and apply business rules to achive a use case.
///
/// The use cases situated on top of models and the “ports” for the data access layer (used for dependency inversion, usually Repository interfaces), retrieve and store domain models by using either repositories or other use cases.
protocol CurrencyUseCase {
    /// Get the latest exchange rates available from the Open Exchange Rates API.
    func exchangeRate() async throws -> ExchangeRateResponse

    /// Get a list of currency symbols.
    func currencies() async throws -> ExchangeCurrencyResponse
}

/// An object that manages the weather data and apply business rules to achive a use case.
struct DefaultCurrencyUseCase: CurrencyUseCase {
    // MARK: Dependencies

    /// An object provides methods for interacting with the exchange currency data in the remote database.
    private let remoteCurrencyRepository: RemoteCurrencyRepository

    // MARK: Init

    /// Initiate an object that manages the weather data and apply business rules to achive a use case.
    /// - Parameter remoteCurrencyRepository: An object provides methods for interacting with the exchange currency data in the remote database.
    init(remoteCurrencyRepository: RemoteCurrencyRepository = DefaultRemoteCurrencyRepository()) {
        self.remoteCurrencyRepository = remoteCurrencyRepository
    }

    // MARK: CurrencyConverterUseCase

    func exchangeRate() async throws -> ExchangeRateResponse {
        try await remoteCurrencyRepository.exchangeRate()
    }

    func currencies() async throws -> ExchangeCurrencyResponse {
        try await remoteCurrencyRepository.currencies()
    }
}
