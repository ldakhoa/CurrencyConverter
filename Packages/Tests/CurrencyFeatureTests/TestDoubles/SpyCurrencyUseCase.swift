import XCTest
@testable import CurrencyFeature

final class SpyCurrencyUseCase: CurrencyUseCase {

   // MARK: - exchangeRate

    var exchangeRateThrowableError: Error?
    var exchangeRateCallsCount = 0
    var exchangeRateCalled: Bool {
        exchangeRateCallsCount > 0
    }
    var exchangeRateReturnValue: ExchangeRateResponse!
    var exchangeRateClosure: (() throws -> ExchangeRateResponse)?

    func exchangeRate() throws -> ExchangeRateResponse {
        exchangeRateCallsCount += 1
        if let error = exchangeRateThrowableError {
            throw error
        }
        return try exchangeRateClosure.map({ try $0() }) ?? exchangeRateReturnValue
    }

   // MARK: - currencies

    var currenciesThrowableError: Error?
    var currenciesCallsCount = 0
    var currenciesCalled: Bool {
        currenciesCallsCount > 0
    }
    var currenciesReturnValue: ExchangeCurrencyResponse!
    var currenciesClosure: (() throws -> ExchangeCurrencyResponse)?

    func currencies() throws -> ExchangeCurrencyResponse {
        currenciesCallsCount += 1
        if let error = currenciesThrowableError {
            throw error
        }
        return try currenciesClosure.map({ try $0() }) ?? currenciesReturnValue
    }
}
