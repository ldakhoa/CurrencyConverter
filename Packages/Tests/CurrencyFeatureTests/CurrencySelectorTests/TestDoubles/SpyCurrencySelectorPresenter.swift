import Foundation
@testable import CurrencyFeature

final class SpyCurrencySelectorPresenter: CurrencySelectorPresentable {

   // MARK: - viewDidLoad

    var viewDidLoadCallsCount = 0
    var viewDidLoadCalled: Bool {
        viewDidLoadCallsCount > 0
    }
    var viewDidLoadClosure: (() -> Void)?

    func viewDidLoad() {
        viewDidLoadCallsCount += 1
        viewDidLoadClosure?()
    }

   // MARK: - keywordsDidChange

    var keywordsDidChangeCallsCount = 0
    var keywordsDidChangeCalled: Bool {
        keywordsDidChangeCallsCount > 0
    }
    var keywordsDidChangeReceivedKeywords: String?
    var keywordsDidChangeReceivedInvocations: [String] = []
    var keywordsDidChangeClosure: ((String) -> Void)?

    func keywordsDidChange(_ keywords: String) {
        keywordsDidChangeCallsCount += 1
        keywordsDidChangeReceivedKeywords = keywords
        keywordsDidChangeReceivedInvocations.append(keywords)
        keywordsDidChangeClosure?(keywords)
    }

   // MARK: - numberOfSections

    var numberOfSectionsCallsCount = 0
    var numberOfSectionsCalled: Bool {
        numberOfSectionsCallsCount > 0
    }
    var numberOfSectionsReturnValue: Int! = 0
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
    var numberOfItemsInReturnValue: Int! = 0
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

   // MARK: - didSelectCurrency

    var didSelectCurrencyAtCallsCount = 0
    var didSelectCurrencyAtCalled: Bool {
        didSelectCurrencyAtCallsCount > 0
    }
    var didSelectCurrencyAtReceivedIndexPath: IndexPath?
    var didSelectCurrencyAtReceivedInvocations: [IndexPath] = []
    var didSelectCurrencyAtClosure: ((IndexPath) -> Void)?

    func didSelectCurrency(at indexPath: IndexPath) {
        didSelectCurrencyAtCallsCount += 1
        didSelectCurrencyAtReceivedIndexPath = indexPath
        didSelectCurrencyAtReceivedInvocations.append(indexPath)
        didSelectCurrencyAtClosure?(indexPath)
    }
}
