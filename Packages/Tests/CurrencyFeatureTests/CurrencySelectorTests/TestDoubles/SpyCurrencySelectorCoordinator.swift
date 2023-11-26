import Foundation
@testable import CurrencyFeature

final class SpyCurrencySelectorCoordinator: CurrencySelectorCoordinating {

   // MARK: - close

    var closeCallsCount = 0
    var closeCalled: Bool {
        closeCallsCount > 0
    }
    var closeClosure: (() -> Void)?

    func close() {
        closeCallsCount += 1
        closeClosure?()
    }
}
