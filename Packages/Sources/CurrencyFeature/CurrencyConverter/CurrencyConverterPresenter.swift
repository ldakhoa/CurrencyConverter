import Foundation

protocol CurrencyConverterCoordinating: AnyObject {
    func presentCurrencySelector()
}

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

final class CurrencyConverterPresenter: CurrencyConverterPresentable {
    // MARK: Dependencies

    let currencyUseCase: CurrencyUseCase

    weak var coordinator: CurrencyConverterCoordinating?

    weak var view: CurrencyConverterViewable?

    // MARK: Misc

    /// An asynchronous task that reload all data.
    private(set) var reloadDataTask: Task<Void, Error>?

    /// An asynchronous task that reload all data after a specific time.
    private(set) var pendingReloadDataWorkItem: DispatchWorkItem?

    // MARK: Init

    init(currencyUseCase: CurrencyUseCase = DefaultCurrencyUseCase()) {
        self.currencyUseCase = currencyUseCase
    }

    // MARK: Deinit

    deinit {
        reloadDataTask?.cancel()
    }

    // MARK: CurrencyConverterPresentable

    func amountDidChange(_ value: String?) {
        // Cancel the pending item.
        pendingReloadDataWorkItem?.cancel()
        // Cancel the in-progress request.
        reloadDataTask?.cancel()
        // Wrap a new task in an item.
        let item = DispatchWorkItem(qos: .userInteractive) { [weak self] in
            guard let self else { return }
            // Send a new request to reload data
//            self.reloadData()
        }
        // Keep a reference to the pending task for canceling if needed.
        pendingReloadDataWorkItem = item
        // Schedule to execute the task after a specific time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
    }

    func didTappedCurrencySelector() {
        coordinator?.presentCurrencySelector()
    }

    // MARK: Side Effects

    func reloadData() {
        reloadDataTask?.cancel()
        reloadDataTask = Task {
            do {
                let result = try await currencyUseCase.exchangeRate()
                print(result)
                print(result.rates)
            } catch {
                print(error)
            }
        }
    }
}
