import UIKit

protocol CurrencySelectorPresentable: AnyObject {
    /// Notify the view is loaded into memory.
    func viewDidLoad()

    /// Notify that the keywords did change.
    /// - Parameter keywords: The textual content of the search criteria.
    func keywordsDidChange(_ keywords: String)

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

    /// Notifies that an item was selected at index path.
    func didSelectCurrency(at indexPath: IndexPath)
}

final class CurrencySelectorViewController: UIViewController, CurrencySelectorViewable {
    // MARK: UIs

    private(set) lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.keyboardDismissMode = .interactive
        view.dataSource = self
        view.delegate = self
        view.register(CurrencySelectorCell.self, forCellReuseIdentifier: CurrencySelectorCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// A view controller that manages the display of search results based on interactions with a search bar.
    private(set) lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = NSLocalizedString("Search currency or country", comment: "A search bar placeholder")
        controller.searchBar.accessibilityTraits = .searchField
        controller.searchBar.accessibilityLabel = NSLocalizedString("Search currency or country", comment: "A search bar accessibility label")
        controller.searchBar.isAccessibilityElement = true
        return controller
    }()

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
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(onDismiss)
        )
        title = "Select a currency"
        presenter.viewDidLoad()
    }

    // MARK: CurrencySelectorViewable

    func reloadData() {
        tableView.reloadData()
        UIAccessibility.post(notification: .layoutChanged, argument: nil)
    }

    // MARK: Side Effects

    @objc
    private func onDismiss() {
        dismiss(animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension CurrencySelectorViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.keywordsDidChange(searchController.searchBar.text ?? "")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CurrencySelectorViewController: UITableViewDataSource, UITableViewDelegate {
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
        guard let cell: CurrencySelectorCell = tableView.dequeueReusableCell(
            withIdentifier: CurrencySelectorCell.identifier,
            for: indexPath
        ) as? CurrencySelectorCell else {
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
        40
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter.didSelectCurrency(at: indexPath)
    }
}
