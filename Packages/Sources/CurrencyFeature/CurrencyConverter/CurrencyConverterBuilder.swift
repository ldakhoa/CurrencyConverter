import UIKit

public struct CurrencyConverterBuilder {
    public init() {}

    public func build() -> UIViewController {
        let presenter = CurrencyConverterPresenter()
        let viewController = CurrencyConverterViewController(presenter: presenter)
        presenter.view = viewController
        presenter.coordinator = viewController
        return viewController
    }
}
