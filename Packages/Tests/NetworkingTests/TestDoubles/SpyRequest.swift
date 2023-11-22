import Foundation
@testable import Networking

final class SpyRequest: Request {

    var invokedHeadersGetter = false
    var invokedHeadersGetterCalledCount = 0
    var stubbedHeaders: [String: String]!
    var headers: [String: String]? {
        invokedHeadersGetter = true
        invokedHeadersGetterCalledCount += 1
        return stubbedHeaders
    }

    var invokedUrlGetter = false
    var invokedUrlGetterCalledCount = 0
    var stubbedUrl: String! = ""
    var url: String {
        invokedUrlGetter = true
        invokedUrlGetterCalledCount += 1
        return stubbedUrl
    }

    var invokedMethodGetter = false
    var invokedMethodGetterCalledCount = 0
    var stubbedMethod: Networking.Method!
    var method: Networking.Method {
        invokedMethodGetter = true
        invokedMethodGetterCalledCount += 1
        return stubbedMethod
    }

    var invokedBody = false
    var invokedBodyCalledCount = 0
    var stubbedBodyError: Error?
    var stubbedBodyResult: Data!
    func body() throws -> Data? {
        invokedBody = true
        invokedBodyCalledCount += 1
        if let error = stubbedBodyError {
            throw error
        }
        return stubbedBodyResult
    }
}
