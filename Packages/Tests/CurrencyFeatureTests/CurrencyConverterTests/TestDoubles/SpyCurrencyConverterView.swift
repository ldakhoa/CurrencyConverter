import XCTest
@testable import CurrencyFeature

final class SpyCurrencyConverterView: CurrencyConverterViewable {

   // MARK: - reloadData

    var reloadDataCallsCount = 0
    var reloadDataCalled: Bool {
        reloadDataCallsCount > 0
    }
    var reloadDataClosure: (() -> Void)?

    func reloadData() {
        reloadDataCallsCount += 1
        reloadDataClosure?()
    }

   // MARK: - showLoading

    var showLoadingCallsCount = 0
    var showLoadingCalled: Bool {
        showLoadingCallsCount > 0
    }
    var showLoadingClosure: (() -> Void)?

    func showLoading() {
        showLoadingCallsCount += 1
        showLoadingClosure?()
    }

   // MARK: - hideLoading

    var hideLoadingCallsCount = 0
    var hideLoadingCalled: Bool {
        hideLoadingCallsCount > 0
    }
    var hideLoadingClosure: (() -> Void)?

    func hideLoading() {
        hideLoadingCallsCount += 1
        hideLoadingClosure?()
    }

   // MARK: - showError

    var showErrorCallsCount = 0
    var showErrorCalled: Bool {
        showErrorCallsCount > 0
    }
    var showErrorReceivedError: Error?
    var showErrorReceivedInvocations: [Error] = []
    var showErrorClosure: ((Error) -> Void)?

    func showError(_ error: Error) {
        showErrorCallsCount += 1
        showErrorReceivedError = error
        showErrorReceivedInvocations.append(error)
        showErrorClosure?(error)
    }

   // MARK: - shouldEnableSelectCurrencyButton

    var shouldEnableSelectCurrencyButtonCallsCount = 0
    var shouldEnableSelectCurrencyButtonCalled: Bool {
        shouldEnableSelectCurrencyButtonCallsCount > 0
    }
    var shouldEnableSelectCurrencyButtonReceivedEnabled: Bool?
    var shouldEnableSelectCurrencyButtonReceivedInvocations: [Bool] = []
    var shouldEnableSelectCurrencyButtonClosure: ((Bool) -> Void)?

    func shouldEnableSelectCurrencyButton(_ enabled: Bool) {
        shouldEnableSelectCurrencyButtonCallsCount += 1
        shouldEnableSelectCurrencyButtonReceivedEnabled = enabled
        shouldEnableSelectCurrencyButtonReceivedInvocations.append(enabled)
        shouldEnableSelectCurrencyButtonClosure?(enabled)
    }
}
