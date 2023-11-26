import XCTest
@testable import CurrencyFeature

final class SpyCurrencyConverterCoordinator: CurrencyConverterCoordinating {

   // MARK: - presentCurrencySelector

    var presentCurrencySelectorWithCurrencyRatesCallsCount = 0
    var presentCurrencySelectorWithCurrencyRatesCalled: Bool {
        presentCurrencySelectorWithCurrencyRatesCallsCount > 0
    }
    var presentCurrencySelectorWithCurrencyRatesReceivedCurrencyRates: [ExchangeCurrencyRate]?
    var presentCurrencySelectorWithCurrencyRatesReceivedInvocations: [[ExchangeCurrencyRate]] = []
    var presentCurrencySelectorWithCurrencyRatesClosure: (([ExchangeCurrencyRate]) -> Void)?

    func presentCurrencySelector(withCurrencyRates currencyRates: [ExchangeCurrencyRate]) {
        presentCurrencySelectorWithCurrencyRatesCallsCount += 1
        presentCurrencySelectorWithCurrencyRatesReceivedCurrencyRates = currencyRates
        presentCurrencySelectorWithCurrencyRatesReceivedInvocations.append(currencyRates)
        presentCurrencySelectorWithCurrencyRatesClosure?(currencyRates)
    }
}
