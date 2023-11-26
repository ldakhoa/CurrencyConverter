import Foundation
@testable import CurrencyFeature

final class SpyCurrencySelectorView: CurrencySelectorViewable {

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
}
