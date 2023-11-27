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

    func test_init() {
        XCTAssertIdentical(sut.currencyUseCase as! SpyCurrencyUseCase, useCase)
    }
}

extension CurrencyConverterPresenterTests {
    private func makeCurrencyUseCase() -> SpyCurrencyUseCase {
        let useCase = SpyCurrencyUseCase()
        return useCase
    }
}
