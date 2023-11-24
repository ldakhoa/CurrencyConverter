import Foundation
import Common

/// An object takes the responsibility of routing through the app.
protocol CurrencyConverterCoordinating: AnyObject {
    /// Present the currency selector scene.
    /// - Parameter currencyRates: A list of currency rates.
    func presentCurrencySelector(withCurrencyRates currencyRates: [ExchangeCurrencyRate])
}

/// A passive object that displays currency rates.
protocol CurrencyConverterViewable: AnyObject {
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

/// An object that acts upon the currency rate data and the associated view to display the currency converter.
final class CurrencyConverterPresenter: CurrencyConverterPresentable {
    // MARK: Dependencies

    /// An object that manages the weather data and apply business rules to achive a use case.
    let currencyUseCase: CurrencyUseCase

    /// An object takes the responsibility of routing through the app.
    weak var coordinator: CurrencyConverterCoordinating?

    /// A passive object that displays currency rates.
    weak var view: CurrencyConverterViewable?

    // MARK: Misc

    /// A list of currency rates.
    private(set) var exchangeCurrencyRates: [ExchangeCurrencyRate] = []

    /// An object that temporarily stores transient key-value pairs that are subject to eviction when resources are low or expired.
    let cache = Cache<String, [ExchangeCurrencyRate]>()

    /// Selected currency symbol. Default is USD.
    private(set) var selectedCurrencySymbol: String = "USD"

    /// An asynchronous task that reload all data.
    private(set) var reloadDataTask: Task<Void, Error>?

    /// An asynchronous task that reload all data after a specific time.
    private(set) var pendingReloadDataWorkItem: DispatchWorkItem?

    /// The last amount. Used for avoid re-calculate and re-call APIs.
    private(set) var lastAmount: Double = 0.0

    // MARK: Init

    /// Initiate a presenter that acts upon the currency rate data and the associated view to display the currency converter.
    /// - Parameter currencyUseCase: An object that manages the weather data and apply business rules to achive a use case.
    init(currencyUseCase: CurrencyUseCase = DefaultCurrencyUseCase()) {
        self.currencyUseCase = currencyUseCase
    }

    // MARK: Deinit

    deinit {
        reloadDataTask?.cancel()
    }

    // MARK: CurrencyConverterPresentable

    func amountDidChange(_ value: String?) {
        // Make sure value is double
        guard
            let value,
            let verifyValue = Double(value),
            lastAmount != verifyValue
        else {
            return
        }
        lastAmount = verifyValue

        // Cancel the pending item.
        pendingReloadDataWorkItem?.cancel()
        // Cancel the in-progress request.
        reloadDataTask?.cancel()
        // Wrap a new task in an item.
        let item = DispatchWorkItem(qos: .userInteractive) { [weak self] in
            guard let self else { return }
            // Send a new request to reload data
            self.reloadData(withAmount: verifyValue)
        }
        // Keep a reference to the pending task for canceling if needed.
        pendingReloadDataWorkItem = item
        // Schedule to execute the task after a specific time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
    }

    func didTappedCurrencySelector() {
        coordinator?.presentCurrencySelector(withCurrencyRates: exchangeCurrencyRates)
    }

    func numberOfSections() -> Int {
        exchangeCurrencyRates.isEmpty ? 0 : 1
    }

    func numberOfItems(in section: Int) -> Int {
        exchangeCurrencyRates.count
    }

    func item(at indexPath: IndexPath) -> ExchangeCurrencyRate {
        exchangeCurrencyRates[indexPath.row]
    }

    func handleSelected(currencySymbol: String) {
        selectedCurrencySymbol = currencySymbol
        reloadData(withAmount: lastAmount)
    }

    // MARK: Side Effects

    /// Reloads the data with the specified amount for the selected currency symbol.
    /// - Parameter amount: The amount to convert.
    func reloadData(withAmount amount: Double) {
        // Check if cached exchange currency rates exist
        if let cached = cache.value(forKey: Constant.exchangeCurrencyRateKey) {
            return reloadData(
                withSelectedCurrencySymbol: selectedCurrencySymbol,
                defaultCurrencyRates: cached,
                amount: amount
            )
        }

        reloadDataTask?.cancel()
        reloadDataTask = Task {
            do {
                updateLayout { [weak view] in view?.showLoading() }
                async let exchangeRateResponse = try await currencyUseCase.exchangeRate()
                async let currencies = try await currencyUseCase.currencies()
                updateLayout { [weak view] in view?.hideLoading() }

                let defaultExchangeCurrencyRates: [ExchangeCurrencyRate] = makeDefaultExchangeCurrencyRates(
                    from: try await exchangeRateResponse,
                    andCurrencyResponse: try await currencies
                )
                cache.insert(defaultExchangeCurrencyRates, forKey: Constant.exchangeCurrencyRateKey)

                // Reload data with selected currency symbol and default rates
                reloadData(
                    withSelectedCurrencySymbol: selectedCurrencySymbol,
                    defaultCurrencyRates: defaultExchangeCurrencyRates,
                    amount: amount
                )
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

    /// Creates default exchange currency rates from the exchange rate response and currency response.
    /// - Parameters:
    ///   - exchangeRateResponse: The response containing exchange rates.
    ///   - currencyResponse: The response containing currency information.
    /// - Returns: An array of default exchange currency rates.
    private func makeDefaultExchangeCurrencyRates(
        from exchangeRateResponse: ExchangeRateResponse,
        andCurrencyResponse currencyResponse: ExchangeCurrencyResponse
    ) -> [ExchangeCurrencyRate] {
        exchangeRateResponse
            .rates
            .compactMap { symbol, rate -> ExchangeCurrencyRate? in
                guard let name = currencyResponse[symbol] else { return nil }
                return ExchangeCurrencyRate(name: name, symbol: symbol, rate: rate)
            }
            .sorted(by: { $0.name < $1.name })
    }

    /// Reloads the data with the specified selected currency symbol, default currency rates, and amount.
    /// - Parameters:
    ///   - selectedCurrencySymbol: The selected currency symbol.
    ///   - defaultCurrencyRates: The default currency rates.
    ///   - amount: The amount to convert.
    private func reloadData(
        withSelectedCurrencySymbol selectedCurrencySymbol: String,
        defaultCurrencyRates: [ExchangeCurrencyRate],
        amount: Double
    ) {
        guard let selectedRate = defaultCurrencyRates.first(where: { $0.symbol == selectedCurrencySymbol }) else { return }

        let convertedRates = defaultCurrencyRates.map { currencyRate -> ExchangeCurrencyRate in
            let convertedRate = (currencyRate.rate / selectedRate.rate) * amount
            return ExchangeCurrencyRate(
                name: currencyRate.name,
                symbol: currencyRate.symbol,
                rate: convertedRate
            )
        }

        self.exchangeCurrencyRates = convertedRates
        updateLayout { [weak view] in view?.reloadData() }
    }

    /// Verify the current thread to make sure the task is always executed on the main thread.
    /// - Parameter task: A task that updates the layout.
    private func updateLayout(_ task: @escaping () -> Void) {
        guard !Thread.isMainThread else { return task() }
        DispatchQueue.main.async(execute: task)
    }
}

// MARK: - Constant

private extension CurrencyConverterPresenter {
    enum Constant {
        static let exchangeCurrencyRateKey = "exchangeCurrencyRateKey"
    }
}
