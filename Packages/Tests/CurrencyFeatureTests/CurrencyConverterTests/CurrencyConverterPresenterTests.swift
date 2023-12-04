import XCTest
@testable import CurrencyFeature

final class CurrencyConverterPresenterTests: XCTestCase {
    private var useCase: SpyCurrencyUseCase!
    private var view: SpyCurrencyConverterView!
    private var sut: CurrencyConverterPresenter!
    private var coordinator: SpyCurrencyConverterCoordinator!

    override func setUpWithError() throws {
        useCase = makeCurrencyUseCase()
        view = SpyCurrencyConverterView()
        coordinator = SpyCurrencyConverterCoordinator()
        sut = CurrencyConverterPresenter(currencyUseCase: useCase)
        sut.view = view
        sut.coordinator = coordinator
    }

    override func tearDownWithError() throws {
        useCase = nil
        view = nil
        sut = nil
        coordinator = nil
    }

    // MARK: Test Case - init(currencyUseCase:)

    func test_init() throws {
        let useCase = try XCTUnwrap(sut.currencyUseCase as? SpyCurrencyUseCase)
        XCTAssertIdentical(useCase, self.useCase)
    }

    // MARK: Test Case - currencyKeywordsDidChange(_:)

    func test_currencyKeywordsDidChange_andKeywordsIsNone() {

    }

    func test_currencyKeywordsDidChange_andKeywordsIsSome() {

    }

    // MARK: Test Case - reloadData(withAmount:)

    func test_reloadData_whenCacheIsMissed_andReloadedDataIsTheSame() {

    }

    func test_reloadData_whenCacheIsMissed_andReloadedDataIsDifferent() {

    }

    func test_reloadData_whenCacheIsMissed_andEncounterError() throws {

    }

    func test_reloadData_whenCacheIsMissed_andEncounterError_becauseTaskWasCancelled() throws {

    }

    func test_reloadData_whenCacheIsHit_andCacheDataIsTheSame() throws {

    }

    func test_reloadData_whenCacheIsHit_andCacheDataIsDifferent() throws {

    }

    // MARK: Test Case - amountDidChange(_:)

    func test_amountDidChange_whenAmountIsSame() {

    }

    func test_amountDidChange_whenAmountIsDifferent() {

    }

    func test_amountDidChange_whenAmountIsDifferent_andBeingCalledMultipleTimes() {

    }

    // MARK: Test Case - didTappedCurrencySelector()

    func test_didTappedCurrencySelector() throws {
        sut.didTappedCurrencySelector()
        XCTAssertTrue(coordinator.presentCurrencySelectorWithCurrencyRatesCalled)
        XCTAssertEqual(coordinator.presentCurrencySelectorWithCurrencyRatesCallsCount, 1)
    }

    // MARK: Test Case - numberOfSection()

    func test_numberOfSection_whenDataIsEmpty() {
        XCTAssertEqual(sut.numberOfSections(), 0)
    }

    func test_numberOfSection_whenDataIsSome() {
        sut = CurrencyConverterPresenter(
            currencyUseCase: useCase,
            exchangeCurrencyRates: [.dummy]
        )
        XCTAssertEqual(sut.numberOfSections(), 1)
    }

    // MARK: Test Case - numberOfItems(in:)

    func test_numberOfItems_whenDataIsEmpty() {
        XCTAssertEqual(sut.numberOfItems(in: 0), 0)
    }

    func test_numberOfItems_whenDataIsSome() {
        sut = CurrencyConverterPresenter(
            currencyUseCase: useCase,
            exchangeCurrencyRates: [.dummy]
        )
        XCTAssertEqual(sut.numberOfItems(in: 0), 1)
    }

    // MARK: Test Case - item(at:)

    func test_itemAtIndexPath() {
        let exchangeRate = ExchangeCurrencyRate.dummy
        sut = CurrencyConverterPresenter(
            currencyUseCase: useCase,
            exchangeCurrencyRates: [exchangeRate]
        )
        XCTAssertEqual(sut.item(at: IndexPath(row: 0, section: 0)), exchangeRate)

    }

    // MARK: Test Case - handleSelected(currencySymbol:)

    func test_handleSelectedCurrencySymbol() {
        let symbol = "JPY"
        sut.handleSelected(currencySymbol: symbol)
        XCTAssertEqual(sut.selectedCurrencySymbol, symbol)
    }
}

extension CurrencyConverterPresenterTests {
    private func makeCurrencyUseCase() -> SpyCurrencyUseCase {
        let useCase = SpyCurrencyUseCase()
        useCase.exchangeRateReturnValue = .dummy
        useCase.currenciesReturnValue = .dummy
        return useCase
    }
}
