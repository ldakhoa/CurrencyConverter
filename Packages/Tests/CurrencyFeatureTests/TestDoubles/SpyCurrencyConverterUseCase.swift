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
        if let error = exchangeRateThrowableError {
            throw error
        }
        exchangeRateCallsCount += 1
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
        if let error = currenciesThrowableError {
            throw error
        }
        currenciesCallsCount += 1
        return try currenciesClosure.map({ try $0() }) ?? currenciesReturnValue
    }
}
