import XCTest
@testable import CurrencyFeature

final class SpyCurrencyConverterPresenter: CurrencyConverterPresentable {

   // MARK: - amountDidChange

    var amountDidChangeCallsCount = 0
    var amountDidChangeCalled: Bool {
        amountDidChangeCallsCount > 0
    }
    var amountDidChangeReceivedValue: String?
    var amountDidChangeReceivedInvocations: [String?] = []
    var amountDidChangeClosure: ((String?) -> Void)?

    func amountDidChange(_ value: String?) {
        amountDidChangeCallsCount += 1
        amountDidChangeReceivedValue = value
        amountDidChangeReceivedInvocations.append(value)
        amountDidChangeClosure?(value)
    }

   // MARK: - didTappedCurrencySelector

    var didTappedCurrencySelectorCallsCount = 0
    var didTappedCurrencySelectorCalled: Bool {
        didTappedCurrencySelectorCallsCount > 0
    }
    var didTappedCurrencySelectorClosure: (() -> Void)?

    func didTappedCurrencySelector() {
        didTappedCurrencySelectorCallsCount += 1
        didTappedCurrencySelectorClosure?()
    }

   // MARK: - numberOfSections

    var numberOfSectionsCallsCount = 0
    var numberOfSectionsCalled: Bool {
        numberOfSectionsCallsCount > 0
    }
    var numberOfSectionsReturnValue: Int!
    var numberOfSectionsClosure: (() -> Int)?

    func numberOfSections() -> Int {
        numberOfSectionsCallsCount += 1
        return numberOfSectionsClosure.map({ $0() }) ?? numberOfSectionsReturnValue
    }

   // MARK: - numberOfItems

    var numberOfItemsInCallsCount = 0
    var numberOfItemsInCalled: Bool {
        numberOfItemsInCallsCount > 0
    }
    var numberOfItemsInReceivedSection: Int?
    var numberOfItemsInReceivedInvocations: [Int] = []
    var numberOfItemsInReturnValue: Int!
    var numberOfItemsInClosure: ((Int) -> Int)?

    func numberOfItems(in section: Int) -> Int {
        numberOfItemsInCallsCount += 1
        numberOfItemsInReceivedSection = section
        numberOfItemsInReceivedInvocations.append(section)
        return numberOfItemsInClosure.map({ $0(section) }) ?? numberOfItemsInReturnValue
    }

   // MARK: - item

    var itemAtCallsCount = 0
    var itemAtCalled: Bool {
        itemAtCallsCount > 0
    }
    var itemAtReceivedIndexPath: IndexPath?
    var itemAtReceivedInvocations: [IndexPath] = []
    var itemAtReturnValue: ExchangeCurrencyRate!
    var itemAtClosure: ((IndexPath) -> ExchangeCurrencyRate)?

    func item(at indexPath: IndexPath) -> ExchangeCurrencyRate {
        itemAtCallsCount += 1
        itemAtReceivedIndexPath = indexPath
        itemAtReceivedInvocations.append(indexPath)
        return itemAtClosure.map({ $0(indexPath) }) ?? itemAtReturnValue
    }

   // MARK: - handleSelected

    var handleSelectedCurrencySymbolCallsCount = 0
    var handleSelectedCurrencySymbolCalled: Bool {
        handleSelectedCurrencySymbolCallsCount > 0
    }
    var handleSelectedCurrencySymbolReceivedCurrencySymbol: String?
    var handleSelectedCurrencySymbolReceivedInvocations: [String] = []
    var handleSelectedCurrencySymbolClosure: ((String) -> Void)?

    func handleSelected(currencySymbol: String) {
        handleSelectedCurrencySymbolCallsCount += 1
        handleSelectedCurrencySymbolReceivedCurrencySymbol = currencySymbol
        handleSelectedCurrencySymbolReceivedInvocations.append(currencySymbol)
        handleSelectedCurrencySymbolClosure?(currencySymbol)
    }

   // MARK: - currencyKeywordsDidChange

    var currencyKeywordsDidChangeCallsCount = 0
    var currencyKeywordsDidChangeCalled: Bool {
        currencyKeywordsDidChangeCallsCount > 0
    }
    var currencyKeywordsDidChangeReceivedKeywords: String?
    var currencyKeywordsDidChangeReceivedInvocations: [String] = []
    var currencyKeywordsDidChangeClosure: ((String) -> Void)?

    func currencyKeywordsDidChange(_ keywords: String) {
        currencyKeywordsDidChangeCallsCount += 1
        currencyKeywordsDidChangeReceivedKeywords = keywords
        currencyKeywordsDidChangeReceivedInvocations.append(keywords)
        currencyKeywordsDidChangeClosure?(keywords)
    }
}
