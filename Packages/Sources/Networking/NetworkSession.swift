import Foundation

/// An ad-hoc network layer that is built on URLSession to perform an HTTP request.
public final class NetworkSession: NetworkableSession {
    // MARK: Dependencies

    /// A type can build an URL load request that is independent of protocol or URL scheme.
    let requestBuilder: URLRequestBuildable

    /// A list of middlewares that will perform side effects whenever a request is sent or a response is received.
    let middlewares: [Middleware]

    /// An object that coordinates a group of related, network data-transfer tasks.
    let session: URLSession

    // MARK: Init

    /// Initiates an ad-hoc network layer that is built on URLSession to perform an HTTP request.
    /// - Parameters:
    ///   - requestBuilder: A type can build an URL load request that is independent of protocol or URL scheme.
    ///   - middlewares: A list of middlewares that will perform side effects whenever a request is sent or a response is received.
    ///   - session: An object that coordinates a group of related, network data-transfer tasks.
    public init(
        requestBuilder: URLRequestBuildable = URLRequestBuilder(),
        middlewares: [Middleware] = [],
        session: URLSession = .shared
    ) {
        self.requestBuilder = requestBuilder
        self.middlewares = middlewares
        self.session = session
    }

    // MARK: NetworkableSession

    public func data<T>(
        for request: Request,
        decoder: JSONDecoder
    ) async throws -> T where T: Decodable {
        // Makes an URL load request.
        let data = try await data(for: request) as Data
        // Decodes the data to result type.
        let result = try decoder.decode(T.self, from: data)
        // Returns the result.
        return result
    }

    public func data(for request: Request) async throws {
        // Makes an URL load request.
        _ = try await data(for: request) as Data
    }

    private func data(for request: Request) async throws -> Data {
        // Makes an URL load request.
        let request = try makeRequest(of: request, middlewares: middlewares)
        // Make a flag to indicate whether it should notify the middlewares about some errors.
        var shouldForwardError = true
        do {
            // Notifies the middlewares.
            middlewares.forEach { (middleware: Middleware) in
                middleware.willSend(request: request)
            }
            // Loads the request.
            let (data, response) = try await session.data(for: request)
            // Avoids notifying the middlewares about any possible errors below
            shouldForwardError = false
            // Notifies the middlewares.
            try middlewares.forEach { (middleware: Middleware) in
                try middleware.didReceive(response: response, data: data)
            }
            // Returns the result.
            return data
        } catch {
            // Verifies whether it should notifies the middlewares about an error.
            guard shouldForwardError else { throw error }
            // Notifies the middlewares.
            middlewares.forEach { (middleware: Middleware) in
                middleware.didReceive(error: error, of: request)
            }
            // Returns the result.
            throw error
        }
    }

    // MARK: Utilities

    /// Makes an URL load request that is independent of protocol or URL scheme from a model.
    ///
    /// It will invoke the middlewares to perform side effects leading the final result.
    ///
    /// - Parameters:
    ///   - request: A type that abstracts an HTTP request.
    ///   - middlewares: A list of middlewares that will perform side effects whenever a request is sent or a response is received.
    /// - Returns: An URL load request that is independent of protocol or URL scheme.
    private func makeRequest(
        of request: Request,
        middlewares: [Middleware]
    ) throws -> URLRequest {
        let seed = try requestBuilder.build(request: request)
        let result = try middlewares.reduce(seed) { (partialResult: URLRequest, middleware: Middleware) in
            try middleware.prepare(request: partialResult)
        }
        return result
    }
}
