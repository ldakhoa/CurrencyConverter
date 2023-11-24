import UIKit
import UIComponentKit
import Toast

/// An object that acts upon the currency rate data and the associated view to display the currency converter.
protocol CurrencyConverterPresentable: AnyObject {
    /// Notifies the presenter that the amount has changed.
    /// - Parameter value: The new value of the amount as a string.
    func amountDidChange(_ value: String?)

    /// Notifies the presenter that the currency selector button has been tapped.
    func didTappedCurrencySelector()

    /// Ask for the number of sections in a list layout.
    /// - Returns: The number of sections in a list layout.
    func numberOfSections() -> Int

    /// Ask for the number of items in the specified section.
    /// - Parameter section: An index number identifying a section.
    /// - Returns: The number of items in section.
    func numberOfItems(in section: Int) -> Int

    /// Ask for a item that is specified by an index path.
    /// - Parameter indexPath: The index path that specifies the location of an item.
    /// - Returns: The data model of an item.
    func item(at indexPath: IndexPath) -> ExchangeCurrencyRate

    /// Handles the selection of a currency symbol.
    /// - Parameter currencySymbol: The selected currency symbol.
    func handleSelected(currencySymbol: String)
}

/// A passive view controller that displays currency rates.
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
        view.accessibilityLabel = NSLocalizedString(
            "Enter amount of money",
            comment: "A text field accessibility label"
        )
        view.isAccessibilityElement = true
        view.addTarget(self, action: #selector(onAmountChanged), for: .editingChanged)
        return view
    }()

    private(set) lazy var selectCurrencyButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(
            self,
            action: #selector(onCurrencySelector),
            for: .touchUpInside
        )
        view.setTitle("USD", for: .normal)
        view.tintColor = .label
        view.titleLabel?.font = .preferredFont(forTextStyle: .headline)

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
        view.accessibilityLabel = NSLocalizedString(
            "Select to change the currency",
            comment: "A button accessibility label"
        )
        view.isAccessibilityElement = true
        return view
    }()

    private(set) lazy var currencyConversionsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.keyboardDismissMode = .interactive
        view.register(
            CurrencyConverterTableViewCell.self,
            forCellReuseIdentifier: CurrencyConverterTableViewCell.identifier
        )
        view.isAccessibilityElement = true
        view.accessibilityLabel = NSLocalizedString(
            "List of currency conversions",
            comment: "A list of currency conversions label"
        )
        view.allowsSelection = false
        view.separatorInset = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0) // since content view inset leading is 8
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
        view.backgroundColor = .systemBackground

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

            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Currency Converter"
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

    @objc
    private func onCurrencySelector() {
        presenter.didTappedCurrencySelector()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CurrencyConverterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter.numberOfItems(in: section)
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell: CurrencyConverterTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyConverterTableViewCell.identifier,
            for: indexPath
        ) as? CurrencyConverterTableViewCell else {
            return UITableViewCell()
        }
        let currencyRate: ExchangeCurrencyRate = presenter.item(at: indexPath)
        cell.configure(withCurrencyRate: currencyRate)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - CurrencySelectorListener

extension CurrencyConverterViewController: CurrencySelectorListener {
    func didSelect(currencyRate: ExchangeCurrencyRate) {
        selectCurrencyButton.setTitle(currencyRate.symbol, for: .normal)
        presenter.handleSelected(currencySymbol: currencyRate.symbol)
    }
}
