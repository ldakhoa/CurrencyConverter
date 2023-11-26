import Foundation
@testable import CurrencyFeature

final class SpyCurrencySelectorListener: CurrencySelectorListener {

   // MARK: - didSelect

    var didSelectCurrencyRateCallsCount = 0
    var didSelectCurrencyRateCalled: Bool {
        didSelectCurrencyRateCallsCount > 0
    }
    var didSelectCurrencyRateReceivedCurrencyRate: ExchangeCurrencyRate?
    var didSelectCurrencyRateReceivedInvocations: [ExchangeCurrencyRate] = []
    var didSelectCurrencyRateClosure: ((ExchangeCurrencyRate) -> Void)?

    func didSelect(currencyRate: ExchangeCurrencyRate) {
        didSelectCurrencyRateCallsCount += 1
        didSelectCurrencyRateReceivedCurrencyRate = currencyRate
        didSelectCurrencyRateReceivedInvocations.append(currencyRate)
        didSelectCurrencyRateClosure?(currencyRate)
    }
}
