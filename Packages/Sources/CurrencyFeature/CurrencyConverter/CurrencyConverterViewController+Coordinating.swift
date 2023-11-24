import UIKit

extension CurrencyConverterViewController: CurrencyConverterCoordinating {
    func presentCurrencySelector(withCurrencies currencies: [ExchangeCurrency]) {
        let presenter = CurrencySelectorPresenter(currencies: currencies)
        let viewController = CurrencySelectorViewController(presenter: presenter)
        presenter.coordinator = viewController
        presenter.view = viewController
        presenter.listener = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
