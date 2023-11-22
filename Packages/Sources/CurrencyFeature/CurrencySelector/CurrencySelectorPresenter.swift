import Foundation

/// An object manages interactions with the currency selector.
protocol CurrencySelectorListener: AnyObject {
    func didSelectCurrency()
}

/// An object takes the responsibility of routing through the app.
protocol CurrencySelectorCoordinating: AnyObject {
    func close()
}

/// A passive object that displays currency symbols and lets the user pick the currency.
protocol CurrencySelectorViewable: AnyObject {

}

final class CurrencySelectorPresenter: CurrencySelectorPresentable {
    // MARK: Dependencies

    let currencyUseCase: CurrencyUseCase

    /// An object manages interactions with the currency selector.
    weak var listener: CurrencySelectorListener?

    /// An object takes the responsibility of routing through the app.
    weak var coordinator: CurrencySelectorCoordinating?

    /// A passive object that displays currency symbols and lets the user pick the currency.
    weak var view: CurrencySelectorViewable?

    // MARK: Init

    init(currencyUseCase: CurrencyUseCase = DefaultCurrencyUseCase()) {
        self.currencyUseCase = currencyUseCase
    }

}
