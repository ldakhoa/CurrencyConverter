import UIKit

// MARK: - CurrencySelectorCoordinating

extension CurrencySelectorViewController: CurrencySelectorCoordinating {
    func close() {
        if #available(iOS 17.0, *) {
            // iOS 17.0 bug.
            // select filter data only dismiss search controller although set `controller.obscuresBackgroundDuringPresentation = false`,
            // we have to dismiss search controller manually first
            searchController.dismiss(animated: false)
        }
        dismiss(animated: true)
    }
}
