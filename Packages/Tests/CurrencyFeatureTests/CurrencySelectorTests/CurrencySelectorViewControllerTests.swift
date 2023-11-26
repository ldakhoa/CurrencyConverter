import XCTest
@testable import CurrencyFeature

final class CurrencySelectorViewControllerTests: XCTestCase {
    private var sut: CurrencySelectorViewController!
    private var presenter: SpyCurrencySelectorPresenter!

    override func setUpWithError() throws {
        presenter = makePresenter()
        sut = CurrencySelectorViewController(presenter: presenter)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        presenter = nil
        sut = nil
    }

    func test_loadView() {
        sut.loadView()
        XCTAssertTrue(sut.tableView.isDescendant(of: sut.view))
    }

    func test_viewDidLoad() {
        sut.viewDidLoad()
        XCTAssertIdentical(sut.navigationItem.searchController, sut.searchController)
        XCTAssertTrue(sut.definesPresentationContext)
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func test_reloadData() {
        sut.reloadData()
    }

    func test_updateSearchResults_whenKeywordAreNone() throws {
        sut.searchController.searchBar.text = nil

        sut.updateSearchResults(for: sut.searchController)

        XCTAssertTrue(presenter.keywordsDidChangeCalled)
        XCTAssertEqual(presenter.keywordsDidChangeReceivedKeywords, "")
    }

    func test_updateSearchResults_whenKeywordAreSome() throws {
        let keywords: String? = "foo"

        sut.searchController.searchBar.text = keywords

        sut.updateSearchResults(for: sut.searchController)

        XCTAssertTrue(presenter.keywordsDidChangeCalled)
        XCTAssertEqual(presenter.keywordsDidChangeReceivedKeywords, keywords)
    }

    func test_numberOfSections() {
        let result = sut.numberOfSections(in: sut.tableView)

        XCTAssertTrue(presenter.numberOfSectionsCalled)
        XCTAssertEqual(result, presenter.numberOfSectionsReturnValue)
    }

    func test_numberOfItemsInSection() {
        let result = sut.tableView(sut.tableView, numberOfRowsInSection: 0)

        XCTAssertTrue(presenter.numberOfItemsInCalled)
        XCTAssertEqual(result, presenter.numberOfItemsInReturnValue)
    }

    func test_cellForRowAtIndexPath() {
        presenter.numberOfSectionsReturnValue = 1
        presenter.numberOfItemsInReturnValue = 1
        presenter.itemAtReturnValue = .dummy

        let indexPath = IndexPath(row: 0, section: 0)
        let result = sut.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertTrue(result is CurrencySelectorCell)
    }

    func test_didSelectRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertFalse(presenter.didSelectCurrencyAtCalled)

        sut.tableView(sut.tableView, didSelectRowAt: indexPath)

        // Then
        XCTAssertTrue(presenter.didSelectCurrencyAtCalled)
        XCTAssertEqual(presenter.didSelectCurrencyAtCallsCount, 1)
        XCTAssertEqual(presenter.didSelectCurrencyAtReceivedIndexPath, indexPath)
    }
}

extension CurrencySelectorViewControllerTests {
    private func makePresenter() -> SpyCurrencySelectorPresenter {
        let result = SpyCurrencySelectorPresenter()
        result.itemAtReturnValue = .dummy
        return result
    }
}
