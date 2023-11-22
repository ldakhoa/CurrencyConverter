import Common
import Foundation
import Networking
import os.log

extension NetworkSession {
    /// A shared instance that connects to the OpenExchangeRates.
    static var openExchangeRates: NetworkSession {
        let baseURL = URL(string: "https://openexchangerates.org/api")
        let requestBuilder: URLRequestBuildable = URLRequestBuilder(baseURL: baseURL)
        let authorizationMiddleware = AuthorizationMiddleware(
            key: "app_id",
            value: Secrets.Config.appID,
            place: .query
        )
        let middlewares: [Middleware] = [
            authorizationMiddleware,
            LoggingMiddleware(log: .networking),
            ErrorDecoderMiddleware<OpenExchangeRateError>(),
            StatusCodeValidationMiddleware(),
        ]
        let session = NetworkSession(
            requestBuilder: requestBuilder,
            middlewares: middlewares
        )
        return session
    }
}

extension OSLog {
    /// A container of networking related log messages.
    static var networking: OSLog {
        OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "networking")
    }
}
