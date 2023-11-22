import UIKit
import UIComponentKit
import Toast

protocol CurrencyConverterPresentable: AnyObject {
    func amountDidChange(_ value: String?)
}

final class CurrencyConverterViewController: UIViewController, CurrencyConverterViewable {
    // MARK: UIs

    private(set) lazy var amountTextField: InsetTextField = {
        let view = InsetTextField(inset: 8.0)
        view.text = "10.0"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardType = .decimalPad
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.cornerRadius = 4.0
        view.textAlignment = .right
        view.accessibilityLabel = NSLocalizedString("Enter amount of money", comment: "A text field accessibility label")
        view.isAccessibilityElement = true
        view.addTarget(self, action: #selector(onAmountChanged), for: .editingChanged)
        return view
    }()

    private(set) lazy var selectCurrencyButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("USD", for: .normal)
        view.tintColor = .label

        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
        view.layer.cornerRadius = 4.0

        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let icon = UIImage(systemName: "chevron.down", withConfiguration: iconConfiguration)
        view.setImage(icon, for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        view.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        view.semanticContentAttribute = .forceRightToLeft
        view.contentHorizontalAlignment = .right

        view.accessibilityTraits = .button
        view.accessibilityLabel = NSLocalizedString("Select to change the currency", comment: "A button accessibility label")
        view.isAccessibilityElement = true
        return view
    }()

    private(set) lazy var currencyConversionsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.keyboardDismissMode = .interactive
        return view
    }()

    /// A view that shows that a task is in progress.
    private(set) lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Dependencies

    let presenter: CurrencyConverterPresentable

    // MARK: Init

    init(presenter: CurrencyConverterPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        let presenter = CurrencyConverterPresenter()
        self.presenter = presenter
        super.init(coder: coder)
        presenter.view = self
        presenter.coordinator = self
    }

    // MARK: Life Cycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(amountTextField)
        view.addSubview(selectCurrencyButton)
        view.addSubview(currencyConversionsTableView)
        view.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            amountTextField.heightAnchor.constraint(equalToConstant: 50),

            selectCurrencyButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 8),
            selectCurrencyButton.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            selectCurrencyButton.widthAnchor.constraint(equalToConstant: 80),
            selectCurrencyButton.heightAnchor.constraint(equalToConstant: 40),

            currencyConversionsTableView.topAnchor.constraint(equalTo: selectCurrencyButton.bottomAnchor, constant: 12),
            currencyConversionsTableView.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            currencyConversionsTableView.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            currencyConversionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: CurrencyConverterViewable

    func reloadData() {
        currencyConversionsTableView.reloadData()
        UIAccessibility.post(notification: .layoutChanged, argument: nil)
    }

    func showLoading() {
        activityIndicatorView.startAnimating()
    }

    func hideLoading() {
        activityIndicatorView.stopAnimating()
    }

    func showError(_ error: Error) {
        let title = error.localizedDescription
        let config = ToastConfiguration(attachTo: view)
        let toast = Toast.text(title, config: config)
        toast.show(haptic: .error)
    }

    // MARK: Side Effects

    @objc
    private func onAmountChanged(_ textField: UITextField) {
        presenter.amountDidChange(textField.text)
    }
}

extension CurrencyConverterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        return cell
    }
}
