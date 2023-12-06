import XCTest
@testable import CurrencyFeature

// swiftlint:disable force_unwrapping
final class CurrencyConverterPresenterTests: XCTestCase {
    private let exchangeCurrencyRateKey = "exchangeCurrencyRateKey"
    private var currencyUseCase: SpyCurrencyUseCase!
    private var view: SpyCurrencyConverterView!
    private var sut: CurrencyConverterPresenter!
    private var coordinator: SpyCurrencyConverterCoordinator!

    override func setUpWithError() throws {
        currencyUseCase = makeCurrencyUseCase()
        view = SpyCurrencyConverterView()
        coordinator = SpyCurrencyConverterCoordinator()
        sut = CurrencyConverterPresenter(currencyUseCase: currencyUseCase)
        sut.view = view
        sut.coordinator = coordinator
    }

    override func tearDownWithError() throws {
        currencyUseCase = nil
        view = nil
        sut = nil
        coordinator = nil
    }

    // MARK: Test Case - init(currencyUseCase:)

    func test_init() throws {
        let useCase = try XCTUnwrap(sut.currencyUseCase as? SpyCurrencyUseCase)
        XCTAssertIdentical(useCase, self.currencyUseCase)
    }

    // MARK: Test Case - currencyKeywordsDidChange(_:)

    func test_currencyKeywordsDidChange_andKeywordsIsNone() {
        sut = CurrencyConverterPresenter(
            currencyUseCase: currencyUseCase,
            exchangeCurrencyRates: [.dummy]
        )
        sut.view = view
        sut.currencyKeywordsDidChange("")

        XCTAssertEqual(sut.filteredCurrencyRates, sut.exchangeCurrencyRates)

        XCTAssertTrue(view.reloadDataCalled)

        XCTAssertTrue(view.shouldEnableSelectCurrencyButtonCalled)
    }

    func test_currencyKeywordsDidChange_andKeywordsIsSome() {
        sut = CurrencyConverterPresenter(
            currencyUseCase: currencyUseCase,
            exchangeCurrencyRates: [.dummy]
        )
        sut.view = view

        sut.currencyKeywordsDidChange("VND")

        XCTAssertNotEqual(sut.filteredCurrencyRates, sut.exchangeCurrencyRates)

        XCTAssertTrue(view.reloadDataCalled)

        XCTAssertTrue(view.shouldEnableSelectCurrencyButtonCalled)

    }

    // MARK: Test Case - reloadData(withAmount:)

    func test_reloadData_whenCacheIsMissed() {
        let reloadDataExpectation = expectation(description: "it will called use case to reload data")
        let presentationExpectation = expectation(description: "it will ask the view to show and hide loading indicator, but not to reload data")

        let amount: Double = 10.0

        currencyUseCase.currenciesReturnValue = [
            "JPY": "10.0",
            "VND": "100.356",
        ]
        currencyUseCase.exchangeRateReturnValue = ExchangeRateResponse(
            disclaimer: "Mock disclaimer",
            license: "Mock license",
            timestamp: 10, base: "USD",
            rates: [
                "JPY": 10.0,
                "VND": 100.356,
            ]
        )
        sut.cache.removeValue(forKey: exchangeCurrencyRateKey)

        XCTAssertNil(sut.reloadDataTask)

        sut.reloadData(withAmount: amount)

        XCTAssertNotNil(sut.reloadDataTask)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned currencyUseCase, unowned view] in
            XCTAssertEqual(currencyUseCase!.currenciesCallsCount, 1)
            XCTAssertEqual(currencyUseCase!.exchangeRateCallsCount, 1)

            reloadDataExpectation.fulfill()

            XCTAssertTrue(view!.showLoadingCalled)
            XCTAssertTrue(view!.hideLoadingCalled)
            XCTAssertFalse(view!.reloadDataCalled)

            presentationExpectation.fulfill()
        }

        wait(for: [reloadDataExpectation, presentationExpectation], timeout: 1)
    }

    func test_reloadData_whenCacheIsMissed_andEncounterError() throws {
        let reloadDataExpectation = expectation(description: "it will called use case to reload data")
        let presentationExpectation = expectation(description: "it will ask the view to show and hide loading indicator, but not to reload data")
        let amount: Double = 10.0

        currencyUseCase.currenciesThrowableError = DummyError()
        currencyUseCase.exchangeRateThrowableError = DummyError()

        XCTAssertNil(sut.reloadDataTask)

        sut.reloadData(withAmount: amount)
        sut.cache.removeValue(forKey: exchangeCurrencyRateKey)

        XCTAssertNotNil(sut.reloadDataTask)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned currencyUseCase, unowned view] in
            XCTAssertEqual(currencyUseCase!.currenciesCallsCount, 1)
            XCTAssertEqual(currencyUseCase!.exchangeRateCallsCount, 1)

            reloadDataExpectation.fulfill()

            XCTAssertTrue(view!.showLoadingCalled)
            XCTAssertTrue(view!.hideLoadingCalled)
            XCTAssertTrue(view!.showErrorCalled)

            presentationExpectation.fulfill()
        }

        wait(for: [reloadDataExpectation, presentationExpectation], timeout: 11)
    }

    func test_reloadData_whenCacheIsMissed_andEncounterError_becauseTaskWasCancelled() throws {
        let reloadDataExpectation = expectation(description: "it will called use case to reload data")
        let presentationExpectation = expectation(description: "it will ask the view to show and hide loading indicator, but not to reload data")

        sut.cache.removeValue(forKey: exchangeCurrencyRateKey)
        currencyUseCase.currenciesThrowableError = NSError(domain: "foo", code: NSError.Code.cancelled.rawValue)

        XCTAssertNil(sut.reloadDataTask)

        sut.reloadData(withAmount: 10.0)

        XCTAssertNotNil(sut.reloadDataTask)

        sut.reloadDataTask?.cancel()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned currencyUseCase, unowned view] in
            XCTAssertEqual(currencyUseCase!.currenciesCallsCount, 1)

            reloadDataExpectation.fulfill()

            XCTAssertTrue(view!.showLoadingCalled)
            XCTAssertTrue(view!.hideLoadingCalled)
            XCTAssertFalse(view!.showErrorCalled)

            presentationExpectation.fulfill()
        }

        wait(for: [reloadDataExpectation, presentationExpectation], timeout: 1)
    }

    func test_reloadData_whenCacheIsHit() throws {
        let reloadDataExpectation = expectation(description: "it will not make APIs call")
        let amount: Double = 10.0

        sut.cache.insert(sut.exchangeCurrencyRates, forKey: exchangeCurrencyRateKey)

        XCTAssertNil(sut.reloadDataTask)

        sut.reloadData(withAmount: amount)

        XCTAssertNil(sut.reloadDataTask)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned currencyUseCase] in
            XCTAssertFalse(currencyUseCase!.currenciesCalled)
            XCTAssertFalse(currencyUseCase!.exchangeRateCalled)

            reloadDataExpectation.fulfill()
        }

        wait(for: [reloadDataExpectation], timeout: 1)
    }

    // MARK: Test Case - amountDidChange(_:)

    func test_amountDidChange_whenAmountIsSame() {
        let lastAmount = "\(sut.lastAmount)"
        sut.amountDidChange(lastAmount)
        XCTAssertNil(sut.pendingReloadDataWorkItem)
        XCTAssertFalse(view.reloadDataCalled)
    }

    func test_amountDidChange_whenAmountIsDifferent_andBeingCalledMultipleTimes() {
        let expectation = expectation(description: "expeced the data will be reload after a while")
        let firstAmount = 10.0
        let secondAmount = 100.0

        sut.cache.removeValue(forKey: exchangeCurrencyRateKey)

        XCTAssertNotEqual(sut.lastAmount, firstAmount)

        sut.amountDidChange("\(firstAmount)")

        XCTAssertEqual(sut.lastAmount, firstAmount)

        let pendingReloadDataWorkItem = sut.pendingReloadDataWorkItem

        sut.amountDidChange("\(secondAmount)")

        XCTAssertEqual(sut.lastAmount, secondAmount)

        XCTAssertNotIdentical(sut.pendingReloadDataWorkItem, pendingReloadDataWorkItem)

        sut.pendingReloadDataWorkItem?.notify(queue: .main) { [unowned currencyUseCase] in
            XCTAssertEqual(currencyUseCase!.currenciesCallsCount, 1)
            XCTAssertEqual(currencyUseCase!.exchangeRateCallsCount, 1)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30)
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
            currencyUseCase: currencyUseCase,
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
            currencyUseCase: currencyUseCase,
            exchangeCurrencyRates: [.dummy]
        )
        XCTAssertEqual(sut.numberOfItems(in: 0), 1)
    }

    // MARK: Test Case - item(at:)

    func test_itemAtIndexPath() {
        let exchangeRate = ExchangeCurrencyRate.dummy
        sut = CurrencyConverterPresenter(
            currencyUseCase: currencyUseCase,
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
// swiftlint:enable force_unwrapping
