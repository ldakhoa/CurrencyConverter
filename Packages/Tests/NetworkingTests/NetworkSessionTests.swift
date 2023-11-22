import XCTest
@testable import Networking

// swiftlint:disable force_unwrapping
final class NetworkSessionTests: XCTestCase {
    // MARK: Misc

    var urlRequest: URLRequest!
    var urlResponse: HTTPURLResponse!
    var data: Data!
    var requestBuilder: SpyURLRequestBuilder!
    var middleware: SpyMiddleware!
    var session: URLSession!
    var sut: NetworkSession!

    // MARK: Life Cycle

    override func setUpWithError() throws {
        urlRequest = makeURLRequest()
        urlResponse = makeURLResponse()
        data = makeData()
        requestBuilder = makeRequestBuilder()
        middleware = makeMiddleware()
        session = .stubbed
        sut = NetworkSession(
            requestBuilder: requestBuilder,
            middlewares: [middleware],
            session: session)

        bootstrapSession()
    }

    override func tearDownWithError() throws {
        urlRequest = nil
        urlResponse = nil
        data = nil
        requestBuilder = nil
        middleware = nil
        session = nil
        sut = nil

        resetSession()
    }

    // MARK: Test Cases - init(requestBuilder:middlewares:session)

    func test_init() throws {
        XCTAssertIdentical(sut.requestBuilder as? SpyURLRequestBuilder, requestBuilder)
        XCTAssertEqual(sut.middlewares as? [SpyMiddleware], [middleware])
        XCTAssertEqual(sut.session, session)
    }

    // MARK: Test Cases - data(for:decoder)

    func test_dataWithDecodableResult_whenMiddlewareEncountersErrorAtPrepareRequest() async throws {
        let dummyError = DummyError()
        middleware.stubbedPrepareError = dummyError

        do {
            _ = try await sut.data(for: makeRequest(), decoder: JSONDecoder()) as DummyCodable
            XCTFail("it should encounter an error")
        } catch {
            XCTAssertEqual(error as? DummyError, dummyError)
            XCTAssertTrue(middleware.invokedPrepare)
            XCTAssertEqual(middleware.invokedPrepareParameters?.request, urlRequest)
            XCTAssertFalse(middleware.invokedWillSend)
            XCTAssertFalse(middleware.invokedDidReceiveResponse)
            XCTAssertFalse(middleware.invokedDidReceiveError)
        }
    }

    func test_dataWithDecodableResult_whenURLSessionEncountersError() async throws {
        let dummyError = DummyError()
        StubbedURLProtocol.stubbedResponseError[urlRequest] = dummyError

        do {
            _ = try await sut.data(for: makeRequest(), decoder: JSONDecoder()) as DummyCodable
            XCTFail("it should encounter an error")
        } catch {
            XCTAssertTrue(middleware.invokedPrepare)
            XCTAssertEqual(middleware.invokedPrepareParameters?.request, urlRequest)
            XCTAssertTrue(middleware.invokedWillSend)
            XCTAssertEqual(middleware.invokedWillSendParameters?.request, urlRequest)
            XCTAssertFalse(middleware.invokedDidReceiveResponse)
            XCTAssertTrue(middleware.invokedDidReceiveError)
            XCTAssertEqual(middleware.invokedDidReceiveErrorParameters?.request, urlRequest)
        }
    }

    func test_dataWithDecodableResult_whenMiddlewareEncountersErrorAtDidReceiveResponse() async throws {
        let dummyError = DummyError()
        middleware.stubbedDidReceiveResponseError = dummyError

        do {
            _ = try await sut.data(for: makeRequest(), decoder: JSONDecoder()) as DummyCodable
            XCTFail("it should encounter an error")
        } catch {
            let spyURLResponse = middleware.invokedDidReceiveResponseParameters?.response as! HTTPURLResponse
            let spyURLResponseHeaders = spyURLResponse.allHeaderFields as! [String: String]
            let urlResponseHeaders = urlResponse.allHeaderFields as! [String: String]
            XCTAssertEqual(error as? DummyError, dummyError)
            XCTAssertTrue(middleware.invokedPrepare)
            XCTAssertEqual(middleware.invokedPrepareParameters?.request, urlRequest)
            XCTAssertTrue(middleware.invokedWillSend)
            XCTAssertEqual(middleware.invokedWillSendParameters?.request, urlRequest)
            XCTAssertTrue(middleware.invokedDidReceiveResponse)
            XCTAssertEqual(spyURLResponse.url, urlResponse.url)
            XCTAssertEqual(spyURLResponse.statusCode, urlResponse.statusCode)
            XCTAssertEqual(spyURLResponseHeaders, urlResponseHeaders)
            XCTAssertEqual(middleware.invokedDidReceiveResponseParameters?.data, data)
            XCTAssertFalse(middleware.invokedDidReceiveError)
        }
    }

    func test_dataWithDecodableResult_whenDecoderEncounterError() async throws {
        do {
            _ = try await sut.data(for: makeRequest(), decoder: JSONDecoder()) as Int
            XCTFail("it should encounter an error")
        } catch {
            let spyURLResponse = middleware.invokedDidReceiveResponseParameters?.response as! HTTPURLResponse
            let spyURLResponseHeaders = spyURLResponse.allHeaderFields as! [String: String]
            let urlResponseHeaders = urlResponse.allHeaderFields as! [String: String]
            XCTAssertTrue(error is DecodingError)
            XCTAssertTrue(middleware.invokedPrepare)
            XCTAssertEqual(middleware.invokedPrepareParameters?.request, urlRequest)
            XCTAssertTrue(middleware.invokedWillSend)
            XCTAssertEqual(middleware.invokedWillSendParameters?.request, urlRequest)
            XCTAssertTrue(middleware.invokedDidReceiveResponse)
            XCTAssertEqual(spyURLResponse.url, urlResponse.url)
            XCTAssertEqual(spyURLResponse.statusCode, urlResponse.statusCode)
            XCTAssertEqual(spyURLResponseHeaders, urlResponseHeaders)
            XCTAssertEqual(middleware.invokedDidReceiveResponseParameters?.data, data)
            XCTAssertFalse(middleware.invokedDidReceiveError)
        }
    }

    func test_dataWithDecodableResult_withCustomDecoder() async throws {
        struct SnakeCase: Decodable { let fooBar: Int }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        StubbedURLProtocol.stubbedData[urlRequest] = #"{"foo_bar":0}"#.data(using: .utf8)

        let result = try await sut.data(for: makeRequest(), decoder: decoder) as SnakeCase

        XCTAssertEqual(result.fooBar, 0)
    }

    // MARK: Test Cases - data(for:)

    func test_data() async throws {
        do {
            try await sut.data(for: makeRequest())
        } catch {
            XCTFail("it should complete without an error")
        }
    }
}

extension NetworkSessionTests {
    // MARK: Utilities

    private func makeURL() -> URL {
        URL(string: "https://foo.bar")!
    }

    func makeRequest() -> Request {
        SpyRequest()
    }

    func makeURLRequest() -> URLRequest {
        URLRequest(url: makeURL())
    }

    func makeURLResponse() -> HTTPURLResponse {
        let result = HTTPURLResponse(
            url: makeURL(),
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["foo": "bar"])!
        return result
    }

    func makeData() -> Data {
        """
        {"foo":"bar"}
        """.data(using: .utf8)!
    }

    func makeRequestBuilder() -> SpyURLRequestBuilder {
        let result = SpyURLRequestBuilder()
        result.stubbedBuildResult = urlRequest
        return result
    }

    func makeMiddleware() -> SpyMiddleware {
        let result = SpyMiddleware()
        result.stubbedPrepareResult = urlRequest
        return result
    }

    func bootstrapSession() {
        StubbedURLProtocol.stubbedResponse[urlRequest] = urlResponse
        StubbedURLProtocol.stubbedData[urlRequest] = data
    }

    func resetSession() {
        StubbedURLProtocol.reset()
    }
}
// swiftlint:enable force_unwrapping
