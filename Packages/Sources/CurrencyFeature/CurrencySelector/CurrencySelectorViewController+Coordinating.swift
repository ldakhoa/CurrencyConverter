import UIKit

// MARK: - CurrencySelectorCoordinating

extension CurrencySelectorViewController: CurrencySelectorCoordinating {
    func close() {
        dismiss(animated: true)
    }
}
