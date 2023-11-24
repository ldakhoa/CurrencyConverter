import Foundation
import Common

/// An object manages interactions with the currency selector.
protocol CurrencySelectorListener: AnyObject {
    /// Notifies that an item was selected.
    func didSelect(currencyRate: ExchangeCurrencyRate)
}

/// An object takes the responsibility of routing through the app.
protocol CurrencySelectorCoordinating: AnyObject {
    func close()
}

/// A passive object that displays currency symbols and lets the user pick the currency.
protocol CurrencySelectorViewable: AnyObject {
    /// Reload all data.
    func reloadData()
}

final class CurrencySelectorPresenter: CurrencySelectorPresentable {
    // MARK: Dependencies

    /// An object manages interactions with the currency selector.
    weak var listener: CurrencySelectorListener?

    /// An object takes the responsibility of routing through the app.
    weak var coordinator: CurrencySelectorCoordinating?

    /// A passive object that displays currency symbols and lets the user pick the currency.
    weak var view: CurrencySelectorViewable?

    // MARK: Misc

    /// A list of currencies.
    private let currencyRates: [ExchangeCurrencyRate]

    /// An asynchronous task that reload all data.
    private(set) var reloadDataTask: Task<Void, Error>?

    // MARK: Init

    init(currencyRates: [ExchangeCurrencyRate]) {
        self.currencyRates = currencyRates
    }

    // MARK: Deinit

    deinit {
        reloadDataTask?.cancel()
    }

    // MARK: CurrencySelectorPresentable

    func viewDidLoad() {}

    func keywordsDidChange(_ keywords: String) {

    }

    func numberOfSections() -> Int {
        currencyRates.isEmpty ? 0 : 1
    }

    func numberOfItems(in section: Int) -> Int {
        currencyRates.count
    }

    func item(at indexPath: IndexPath) -> ExchangeCurrencyRate {
        currencyRates[indexPath.row]
    }

    func didSelectCurrency(at indexPath: IndexPath) {
        listener?.didSelect(currencyRate: currencyRates[indexPath.row])
        coordinator?.close()
    }
}
