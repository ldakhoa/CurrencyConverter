import UIKit

protocol CurrencySelectorPresentable: AnyObject {

}

final class CurrencySelectorViewController: UIViewController, CurrencySelectorViewable {
    // MARK: Dependencies

    let presenter: CurrencySelectorPresentable

    // MARK: Init

    init(presenter: CurrencySelectorPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .red
    }
}
