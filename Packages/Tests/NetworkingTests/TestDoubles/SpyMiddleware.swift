import Foundation
@testable import Networking

final class SpyMiddleware: Middleware, Equatable {
    static func == (lhs: SpyMiddleware, rhs: SpyMiddleware) -> Bool {
        lhs.id == rhs.id
    }

    private let id = UUID()

    var invokedPrepare = false
    var invokedPrepareCalledCount: Int = 0
    var invokedPrepareParameters: (request: URLRequest, Void)?
    var invokedPrepareParametersList = [(request: URLRequest, Void)]()
    var stubbedPrepareError: Error?
    var stubbedPrepareResult: URLRequest!
    func prepare(request: URLRequest) throws -> URLRequest {
        invokedPrepare = true
        invokedPrepareCalledCount += 1
        invokedPrepareParameters = (request, ())
        invokedPrepareParametersList.append((request, ()))
        if let error = stubbedPrepareError {
            throw error
        }
        return stubbedPrepareResult
    }

    var invokedWillSend = false
    var invokedWillSendCalledCount = 0
    var invokedWillSendParameters: (request: URLRequest, Void)?
    var invokedWillSendParametersList = [(request: URLRequest, Void)]()
    func willSend(request: URLRequest) {
        invokedWillSend = true
        invokedWillSendCalledCount += 1
        invokedWillSendParameters = (request, ())
        invokedWillSendParametersList.append((request, ()))
    }

    var invokedDidReceiveResponse = false
    var invokedDidReceiveResponseCalledCount = 0
    var invokedDidReceiveResponseParameters: (response: URLResponse, data: Data)?
    var invokedDidReceiveResponseParametersList = [(response: URLResponse, data: Data)]()
    var stubbedDidReceiveResponseError: Error?
    func didReceive(response: URLResponse, data: Data) throws {
        invokedDidReceiveResponse = true
        invokedDidReceiveResponseCalledCount += 1
        invokedDidReceiveResponseParameters = (response, data)
        invokedDidReceiveResponseParametersList.append((response, data))
        if let error = stubbedDidReceiveResponseError {
            throw error
        }
    }

    var invokedDidReceiveError = false
    var invokedDidReceiveErrorCalledCount = 0
    var invokedDidReceiveErrorParameters: (error: Error, request: URLRequest)?
    var invokedDidReceiveErrorParametersList = [(error: Error, request: URLRequest)]()
    func didReceive(error: Error, of request: URLRequest) {
        invokedDidReceiveError = true
        invokedDidReceiveErrorCalledCount += 1
        invokedDidReceiveErrorParameters = (error, request)
        invokedDidReceiveErrorParametersList.append((error, request))
    }
}
