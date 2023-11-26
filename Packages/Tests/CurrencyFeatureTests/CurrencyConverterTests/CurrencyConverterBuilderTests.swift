import XCTest
@testable import CurrencyFeature

final class CurrencyConverterBuilderTests: XCTestCase {
    private var sut: CurrencyConverterBuilder!

    override func setUpWithError() throws {
        sut = CurrencyConverterBuilder()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_build() throws {
        let viewController = try XCTUnwrap(sut.build() as? CurrencyConverterViewController)
        let presenter = try XCTUnwrap(viewController.presenter as? CurrencyConverterPresenter)

        XCTAssertIdentical(presenter.view, viewController)
        XCTAssertIdentical(presenter.coordinator, viewController)
    }
}
