import Foundation

/// A middleware that determines whether a response is unsuccessfu to decode instances of an error type.
public struct ErrorDecoderMiddleware<Failure>: Middleware where Failure: Error & Decodable {
    // MARK: Dependencies

    /// A range of HTTP response status codes that specifies a response is success.
    let successfulStatusCodes: ResponseStatusCodes

    /// An object that decodes instances of a data type from JSON objects.
    let decoder: JSONDecoder

    // MARK: Init

    public init(
        successfulStatusCodes: ResponseStatusCodes = .success,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.successfulStatusCodes = successfulStatusCodes
        self.decoder = decoder
    }

    // MARK: Middleware

    public func prepare(request: URLRequest) throws -> URLRequest { request }

    public func willSend(request: URLRequest) {}

    public func didReceive(response: URLResponse, data: Data) throws {
        // Verifies the response is an instance of `HTTPURLResponse`.
        guard let response = response as? HTTPURLResponse else { return }
        // Verifies the status code is unsuccessful.
        guard !successfulStatusCodes.contains(response.statusCode) else { return }
        // Try to decode an error.
        guard let result = try? decoder.decode(Failure.self, from: data) else { return }
        // Throw the result.
        throw result
    }

    public func didReceive(error: Error, of request: URLRequest) {}
}
