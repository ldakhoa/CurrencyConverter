import Foundation
import Networking

/// An object provides methods for interacting with the exchange currency data in the remote database.
protocol RemoteCurrencyConverterRepository {
    /// Get the latest exchange rates available from the Open Exchange Rates API.
    func exchangeRate() async throws -> ExchangeRateResponse
}

/// An object provides methods for interacting with the exchange currency data in the remote database.
struct DefaultRemoteCurrencyConverterRepository: RemoteCurrencyConverterRepository {

    // MARK: Dependencies

    /// An ad-hoc network layer built on `URLSession` to perform an HTTP request.
    private let session: NetworkableSession

    /// Initiate an object provides methods for interacting with the weather data in the remote database.
    /// - Parameter provider: An ad-hoc network layer built on `URLSession` to perform an HTTP request. The default value is `NetworkSession.openExchangeRates`.
    init(session: NetworkableSession = NetworkSession.openExchangeRates) {
        self.session = session
    }

    // MARK: RemoteCurrencyConverterRepository

    func exchangeRate() async throws -> ExchangeRateResponse {
        let request = API.latestJSON
        return try await session.data(for: request, decoder: JSONDecoder())
    }
}

// MARK: - Endpoint

extension DefaultRemoteCurrencyConverterRepository {
    /// A type that represents the available API endpoint.
    enum API: Networking.Request {
        /// Git a JSON list of all currency symbols avaible from the Open Exchange Rates API.
        case currencies
        /// Get the latest exchange rates available from the Open Exchange Rates API.
        case latestJSON

        // MARK: Request

        var headers: [String: String]? { nil }

        var url: String {
            switch self {
            case .currencies:
                return "/currencies.json"
            case .latestJSON:
                return "/latest.json"
            }
        }

        var method: Networking.Method { .get }

        func body() throws -> Data? { nil }
    }
}
