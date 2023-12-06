import XCTest
@testable import Networking

// swiftlint:disable force_unwrapping force_try
final class ErrorDecoderMiddlewareTests: XCTestCase {
    // MARK: Misc

    private var error: DummyError!
    private var request: URLRequest!
    private var successfulStatusCodes: ResponseStatusCodes!
    private var decoder: JSONDecoder!
    private var sut: ErrorDecoderMiddleware<DummyError>!

    // MARK: Life Cycle

    override func setUpWithError() throws {
        error = DummyError()
        request = makeRequest()
        successfulStatusCodes = 200...299
        decoder = JSONDecoder()
        sut = ErrorDecoderMiddleware(
            successfulStatusCodes: successfulStatusCodes,
            decoder: decoder)
    }

    override func tearDownWithError() throws {
        error = nil
        request = nil
        successfulStatusCodes = nil
        decoder = nil
        sut = nil
    }

    // MARK: Test Cases prepare(request:)

    func test_prepareRequest() throws {
        XCTAssertEqual(try sut.prepare(request: request), request)
    }

    // MARK: Test Cases - willSend(request:)

    func test_willSendRequest() throws {
        sut.willSend(request: request)
    }

    // MARK: Test Cases - didReceive(response:data)

    func test_didReceiveResponse_whenStatusCodeIsSuccessful_andDataIsSome() throws {
        let response = makeResponse(statusCode: 200)
        let data = makeData(source: error)

        XCTAssertNoThrow(try sut.didReceive(response: response, data: data))
    }

    func test_didReceiveResponse_whenStatusCodeIsUnsuccessful_andDataIsNone() throws {
        let response = makeResponse(statusCode: 500)
        let data = Data()

        XCTAssertNoThrow(try sut.didReceive(response: response, data: data))
    }

    func test_didReceiveResponse_whenStatusCodeIsUnsuccessful_andDataIsSome() throws {
        let response = makeResponse(statusCode: 500)
        let data = makeData(source: error)

        XCTAssertThrowsError(try sut.didReceive(response: response, data: data)) { (failure: Error) in
            XCTAssertEqual(failure as? DummyError, error)
        }
    }

    func test_didReceiveResponse_whenStatusCodeIsUnsuccessful_andDataIsInvalid() throws {
        let response = makeResponse(statusCode: 500)
        let data = #"{}"#.data(using: .utf8)!

        XCTAssertNoThrow(try sut.didReceive(response: response, data: data))
    }

    // MARK: Test Cases - didReceive(error:of)

    func test_didReceiveError() throws {
        sut.didReceive(error: DummyError(), of: request)
    }
}

extension ErrorDecoderMiddlewareTests {
    // MARK: Utilities

    private func makeURL() -> URL {
        URL(string: "https://foo.bar/foo/bar")!
    }

    private func makeRequest() -> URLRequest {
        URLRequest(url: makeURL())
    }

    private func makeResponse(statusCode: Int) -> URLResponse {
        HTTPURLResponse(
            url: makeURL(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!
    }

    private func makeData(source: Encodable) -> Data {
        try! JSONEncoder().encode(source)
    }
}
// swiftlint:enable force_unwrapping force_try
