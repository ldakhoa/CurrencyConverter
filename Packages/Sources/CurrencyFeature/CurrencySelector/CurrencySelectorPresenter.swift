import Foundation
import Common

/// An object manages interactions with the currency selector.
protocol CurrencySelectorListener: AnyObject {
    /// Notifies that an item was selected.
    func didSelect(currency: ExchangeCurrency)
}

/// An object takes the responsibility of routing through the app.
protocol CurrencySelectorCoordinating: AnyObject {
    func close()
}

/// A passive object that displays currency symbols and lets the user pick the currency.
protocol CurrencySelectorViewable: AnyObject {
    /// Reload all data.
    func reloadData()

    /// Show a loading indicator over the current context.
    func showLoading()

    /// Hide any showed loading indicator.
    func hideLoading()

    /// Show an error over the current context.
    /// - Parameter error: A type representing an error value.
    func showError(_ error: Error)
}

final class CurrencySelectorPresenter: CurrencySelectorPresentable, Displaying {
    // MARK: Dependencies

    let currencyUseCase: CurrencyUseCase

    /// An object manages interactions with the currency selector.
    weak var listener: CurrencySelectorListener?

    /// An object takes the responsibility of routing through the app.
    weak var coordinator: CurrencySelectorCoordinating?

    /// A passive object that displays currency symbols and lets the user pick the currency.
    weak var view: CurrencySelectorViewable?

    // MARK: Misc

    /// A list of currencies.
    private(set) var currencies: [ExchangeCurrency] = []

    /// An asynchronous task that reload all data.
    private(set) var reloadDataTask: Task<Void, Error>?

    // MARK: Init

    init(currencyUseCase: CurrencyUseCase = DefaultCurrencyUseCase()) {
        self.currencyUseCase = currencyUseCase
    }

    // MARK: Deinit

    deinit {
        reloadDataTask?.cancel()
    }

    // MARK: CurrencySelectorPresentable

    func viewDidLoad() {
        reloadData()
    }

    func keywordsDidChange(_ keywords: String) {

    }

    func numberOfSections() -> Int {
        currencies.isEmpty ? 0 : 1
    }

    func numberOfItems(in section: Int) -> Int {
        currencies.count
    }

    func item(at indexPath: IndexPath) -> ExchangeCurrency {
        currencies[indexPath.row]
    }

    func didSelectCurrency(at indexPath: IndexPath) {
        listener?.didSelect(currency: currencies[indexPath.row])
        coordinator?.close()
    }

    // MARK: Side Effects

    private func reloadData() {
        reloadDataTask?.cancel()
        reloadDataTask = Task {
            do {
                updateLayout { [weak view] in view?.showLoading() }
                let currencies = try await currencyUseCase.currencies()
                updateLayout { [weak view] in view?.hideLoading() }
                reloadData(withCurrencies: currencies)
            } catch {
                updateLayout { [weak view] in
                    view?.hideLoading()
                    let code = NSError.Code(rawValue: (error as NSError).code)
                    guard code != .cancelled else { return }
                    view?.showError(error)
                }
            }
        }
    }

    private func reloadData(withCurrencies currencies: [ExchangeCurrency]) {
        guard self.currencies != currencies else { return }
        self.currencies = currencies
        updateLayout { [weak view] in
            view?.reloadData()
        }
    }
}
