import XCTest
@testable import CurrencyFeature

final class CurrencyConverterTableViewCellTests: XCTestCase {
    private var sut: CurrencyConverterTableViewCell!
    private var currencyRate: ExchangeCurrencyRate!

    override func setUpWithError() throws {
        sut = CurrencyConverterTableViewCell()
        currencyRate = makeCurrencyRate()
    }

    override func tearDownWithError() throws {
        sut = nil
        currencyRate = nil
    }

    func test_setupLayout() throws {
        XCTAssertTrue(sut.containerStackView.isDescendant(of: sut.contentView))

        let nameLabel = try XCTUnwrap(sut.nameLabel.accessibilityLabel)
        XCTAssertFalse(nameLabel.isEmpty)

        let amountLabel = try XCTUnwrap(sut.amountLabel.accessibilityLabel)
        XCTAssertFalse(amountLabel.isEmpty)
    }

    func test_configureWithCurrencyRate() throws {
        sut.configure(withCurrencyRate: currencyRate)
        XCTAssertEqual(sut.nameLabel.text, "Japanese Yen")
        XCTAssertEqual(sut.amountLabel.text, "162.21 JPY")
    }

    private func makeCurrencyRate() -> ExchangeCurrencyRate {
        ExchangeCurrencyRate(name: "Japanese Yen", symbol: "JPY", rate: 162.2143)
    }
}
