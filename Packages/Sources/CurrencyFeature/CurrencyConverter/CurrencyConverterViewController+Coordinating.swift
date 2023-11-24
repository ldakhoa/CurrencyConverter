import UIKit

extension CurrencyConverterViewController: CurrencyConverterCoordinating {
    func presentCurrencySelector(withCurrencyRates currencyRates: [ExchangeCurrencyRate]) {
        let presenter = CurrencySelectorPresenter(currencyRates: currencyRates)
        let viewController = CurrencySelectorViewController(presenter: presenter)
        presenter.coordinator = viewController
        presenter.view = viewController
        presenter.listener = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
