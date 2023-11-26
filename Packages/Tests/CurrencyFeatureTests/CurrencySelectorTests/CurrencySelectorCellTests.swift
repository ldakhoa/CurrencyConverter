import XCTest
@testable import CurrencyFeature

final class CurrencySelectorCellTests: XCTestCase {
    private var sut: CurrencySelectorCell!
    private var currencyRate: ExchangeCurrencyRate!

    override func setUpWithError() throws {
        sut = CurrencySelectorCell()
        currencyRate = makeCurrencyRate()
    }

    override func tearDownWithError() throws {
        sut = nil
        currencyRate = nil
    }

    func test_setupLayout() throws {
        XCTAssertTrue(sut.cellStackView.isDescendant(of: sut.contentView))

        let nameLabel = try XCTUnwrap(sut.nameLabel.accessibilityLabel)
        XCTAssertFalse(nameLabel.isEmpty)

        let symbolLabel = try XCTUnwrap(sut.nameLabel.accessibilityLabel)
        XCTAssertFalse(symbolLabel.isEmpty)
    }

    func test_configureWithCurrencyRate() throws {
        sut.configure(withCurrencyRate: currencyRate)

        XCTAssertEqual(sut.nameLabel.text, "Japanese Yen")
        XCTAssertEqual(sut.symbolLabel.text, "JPY")
    }

    private func makeCurrencyRate() -> ExchangeCurrencyRate {
        ExchangeCurrencyRate(name: "Japanese Yen", symbol: "JPY", rate: 162.0)
    }
}
