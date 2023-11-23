import UIKit

extension CurrencyConverterViewController: CurrencyConverterCoordinating {
    func presentCurrencySelector() {
        let presenter = CurrencySelectorPresenter()
        let viewController = CurrencySelectorViewController(presenter: presenter)
        presenter.coordinator = viewController
        presenter.view = viewController
        presenter.listener = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
