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

/// An object that acts upon the currency rate data and the associated view to display the currency selector.
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
    let currencyRates: [ExchangeCurrencyRate]

    /// A list of filtered currencies.
    private(set) var filteredCurrencyRates: [ExchangeCurrencyRate] = []

    // MARK: Init

    init(currencyRates: [ExchangeCurrencyRate] = []) {
        self.currencyRates = currencyRates
        self.filteredCurrencyRates = currencyRates
    }

    // MARK: CurrencySelectorPresentable

    func viewDidLoad() {}

    func keywordsDidChange(_ keywords: String) {
        filteredCurrencyRates = keywords.isEmpty ? currencyRates : currencyRates.filter {
            $0.name.range(of: keywords, options: .caseInsensitive) != nil ||
            $0.symbol.range(of: keywords, options: .caseInsensitive) != nil
        }
        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }

    func numberOfSections() -> Int {
        filteredCurrencyRates.isEmpty ? 0 : 1
    }

    func numberOfItems(in section: Int) -> Int {
        filteredCurrencyRates.count
    }

    func item(at indexPath: IndexPath) -> ExchangeCurrencyRate {
        filteredCurrencyRates[indexPath.row]
    }

    func didSelectCurrency(at indexPath: IndexPath) {
        listener?.didSelect(currencyRate: filteredCurrencyRates[indexPath.row])
        coordinator?.close()
    }
}
