import UIKit

final class CurrencyConverterTableViewCell: UITableViewCell {

    // MARK: Identifier

    static var identifier: String {
        String(describing: Self.self)
    }

    // MARK: UIs

    private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = .preferredFont(forTextStyle: .callout)
        return view
    }()

    private(set) lazy var amountLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = .preferredFont(forTextStyle: .headline)
        return view
    }()

    private(set) lazy var containerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [amountLabel, nameLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Side Effect

    func configure(withCurrencyRate currencyRate: ExchangeCurrencyRate) {
        let roundedAmount = round(currencyRate.rate * 100) / 100.0
        amountLabel.text = "\(roundedAmount) \(currencyRate.symbol)"
        nameLabel.text = currencyRate.name
    }

    private func setupLayout() {
        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
