import UIKit

/// An object helps to build a currency convert scene that display the currency converter.
public struct CurrencyConverterBuilder {
    // MARK: Init

    public init() {}

    // MARK: Build

    /// Build a scene that display the currency converter.
    /// - Returns: A view controller.
    public func build() -> UIViewController {
        let presenter = CurrencyConverterPresenter()
        let viewController = CurrencyConverterViewController(presenter: presenter)
        presenter.view = viewController
        presenter.coordinator = viewController
        return viewController
    }
}
