import XCTest
@testable import CurrencyFeature

final class CurrencyConverterViewControllerTests: XCTestCase {
    private var sut: CurrencyConverterViewController!
    private var presenter: SpyCurrencyConverterPresenter!

    override func setUpWithError() throws {
        presenter = SpyCurrencyConverterPresenter()
        presenter.itemAtReturnValue = .dummy
        sut = CurrencyConverterViewController(presenter: presenter)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        presenter = nil
        sut = nil
    }

    // MARK: Test Cases - loadView()

    func test_loadView() {
        sut.loadView()

        XCTAssertTrue(sut.amountTextField.isDescendant(of: sut.view))
        XCTAssertTrue(sut.searchCurrencyTextField.isDescendant(of: sut.view))
        XCTAssertTrue(sut.currencyConversionsTableView.isDescendant(of: sut.view))
        XCTAssertTrue(sut.activityIndicatorView.isDescendant(of: sut.view))
        XCTAssertTrue(sut.selectCurrencyButton.isDescendant(of: sut.view))
    }

    // MARK: Test Cases - reloadData()

    func test_reloadData() {
        sut.reloadData()
    }

    // MARK: Test Cases - showLoading()

    func test_showLoading() {
        XCTAssertTrue(sut.activityIndicatorView.isHidden)
        XCTAssertFalse(sut.activityIndicatorView.isAnimating)

        sut.showLoading()

        XCTAssertFalse(sut.activityIndicatorView.isHidden)
        XCTAssertTrue(sut.activityIndicatorView.isAnimating)
    }

    // MARK: Test Cases - hideLoading()

    func test_hideLoading() {
        sut.showLoading()

        XCTAssertFalse(sut.activityIndicatorView.isHidden)
        XCTAssertTrue(sut.activityIndicatorView.isAnimating)

        sut.hideLoading()

        XCTAssertTrue(sut.activityIndicatorView.isHidden)
        XCTAssertFalse(sut.activityIndicatorView.isAnimating)
    }

    // MARK: Test Cases - showError(_:)

    // swiftlint:disable force_unwrapping
    func test_showError() {
        let error = DummyError()
        let top = sut.view.subviews.last!

        sut.showError(error)

        XCTAssertNotIdentical(sut.view.subviews.last!, top)
    }
    // swiftlint:enable force_unwrapping

    // MARK: Test Cases - shouldEnableSelectCurrencyButton(_:)

    func test_shouldEnableSelectCurrencyButton() {
        sut.shouldEnableSelectCurrencyButton(false)

        XCTAssertFalse(sut.selectCurrencyButton.isEnabled)

        sut.shouldEnableSelectCurrencyButton(true)

        XCTAssertTrue(sut.selectCurrencyButton.isEnabled)
    }

    // MARK: Test Cases - numberOfSections(in:)

    func test_numberOfSection() {
        let result = sut.numberOfSections(in: sut.currencyConversionsTableView)

        XCTAssertTrue(presenter.numberOfSectionsCalled)
        XCTAssertEqual(result, presenter.numberOfSectionsReturnValue)
    }

    // MARK: Test Cases - tableView(_:numberOfRowsInSection:)

    func test_numberOfRowsInSection() {
        let result = sut.tableView(sut.currencyConversionsTableView, numberOfRowsInSection: 0)

        XCTAssertTrue(presenter.numberOfItemsInCalled)
        XCTAssertEqual(result, presenter.numberOfItemsInReturnValue)
    }

    // MARK: Test Cases - tableView(_:cellForRowAtIndexPath)

    func test_cellForRowAtIndexPath() {
        presenter.numberOfSectionsReturnValue = 1
        presenter.numberOfItemsInReturnValue = 1
        presenter.itemAtReturnValue = .dummy

        let indexPath = IndexPath(row: 0, section: 0)
        let result = sut.tableView(sut.currencyConversionsTableView, cellForRowAt: indexPath)

        XCTAssertTrue(result is CurrencyConverterTableViewCell)
    }
}
