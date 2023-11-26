import XCTest
@testable import CurrencyFeature

final class CurrencySelectorPresenterTests: XCTestCase {
    private var sut: CurrencySelectorPresenter!
    private var view: SpyCurrencySelectorView!
    private var listener: SpyCurrencySelectorListener!
    private var coordinator: SpyCurrencySelectorCoordinator!

    override func setUpWithError() throws {
        view = SpyCurrencySelectorView()
        listener = SpyCurrencySelectorListener()
        coordinator = SpyCurrencySelectorCoordinator()
        sut = CurrencySelectorPresenter(currencyRates: makeDummyCurrencyRates())
        sut.view = view
        sut.listener = listener
        sut.coordinator = coordinator
    }

    override func tearDownWithError() throws {
        view = nil
        listener = nil
        coordinator = nil
        sut = nil
    }

    // MARK: Test Case - init

    func test_init() throws {
        // Given
        let currencyRates = makeDummyCurrencyRates()

        // When
        sut = CurrencySelectorPresenter(currencyRates: currencyRates)

        // Then
        XCTAssertEqual(sut.currencyRates, currencyRates)
        XCTAssertEqual(sut.filteredCurrencyRates, currencyRates)
    }

    // MARK: Test Case - numberOfSections

    func test_numberOfSections_whenDataIsEmpty() {
        // Given
        let currencyRates: [ExchangeCurrencyRate] = []

        // When
        sut = CurrencySelectorPresenter(currencyRates: currencyRates)

        // Then
        XCTAssertEqual(sut.numberOfSections(), 0)
    }

    func test_numberOfSections_whenDataIsSome() {
        XCTAssertEqual(sut.numberOfSections(), 1)
    }

    // MARK: Test Case - numberOfItems(in:)

    func test_numberOfItems_whenDataIsSome() {
        XCTAssertEqual(sut.numberOfItems(in: 0), 3)
    }

    func test_numberOfItems_whenDataIsNone() {
        // Given
        let currencyRates: [ExchangeCurrencyRate] = []

        // When
        sut = CurrencySelectorPresenter(currencyRates: currencyRates)

        // Then
        XCTAssertEqual(sut.numberOfItems(in: 0), 0)
    }

    // MARK: Test Case - item(at:)

    func test_itemAtIndexPath() {
        XCTAssertEqual(sut.item(at: IndexPath(row: 0, section: 0)), .dummy)
    }

    // MARK: Test Case - didSelectCurrency(at:)

    func test_didSelectCurrencyAtIndexPath_whenListenerIsSome() {
        // When
        sut.didSelectCurrency(at: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertTrue(listener.didSelectCurrencyRateCalled)
        XCTAssertEqual(listener.didSelectCurrencyRateCallsCount, 1)
        XCTAssertEqual(listener.didSelectCurrencyRateReceivedCurrencyRate, makeDummyCurrencyRates()[0])

        XCTAssertTrue(coordinator.closeCalled)
        XCTAssertEqual(coordinator.closeCallsCount, 1)
    }

    func test_didSelectCurrencyAtIndexPath_whenListenerAndCoordinatorIsNone() {
        // When
        sut.listener = nil
        sut.coordinator = nil
        sut.didSelectCurrency(at: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertFalse(listener.didSelectCurrencyRateCalled)
        XCTAssertEqual(listener.didSelectCurrencyRateCallsCount, 0)
        XCTAssertNil(listener.didSelectCurrencyRateReceivedCurrencyRate)

        XCTAssertFalse(coordinator.closeCalled)
        XCTAssertEqual(coordinator.closeCallsCount, 0)
    }

    // MARK: Test Case - keywordsDidChange()

    func test_keywordsDidChange_whenKeywordsIsSome_andInvalidCurrencySymbolOrName() {
        // Given
        let keywords = "Foo"

        // When
        sut.keywordsDidChange(keywords)

        // Then
        XCTAssertTrue(sut.filteredCurrencyRates.isEmpty)
    }

    func test_keywordsDidChange_whenKeywordsIsSome_andValidWithCurrencySymbolOrName() {
        // Given
        var keywords = "Afgh"

        // When
        sut.keywordsDidChange(keywords)

        // Then
        XCTAssertFalse(sut.filteredCurrencyRates.isEmpty)

        // When
        keywords = "AFN"
        sut.keywordsDidChange(keywords)

        // Then
        XCTAssertFalse(sut.filteredCurrencyRates.isEmpty)
    }

    func test_keywordsDidChange_whenKeywordsIsNone() {
        // Given
        let keywords = ""

        // When
        sut.keywordsDidChange(keywords)

        // Then
        XCTAssertFalse(sut.filteredCurrencyRates.isEmpty)
        XCTAssertEqual(sut.filteredCurrencyRates, sut.currencyRates)
    }
}

extension CurrencySelectorPresenterTests {
    private func makeDummyCurrencyRates() -> [ExchangeCurrencyRate] {
        [.dummy, .dummy, .dummy]
    }
}
