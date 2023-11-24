import UIKit

final class CurrencySelectorCell: UITableViewCell {
    // MARK: Identifier

    static var identifier: String {
        String(describing: Self.self)
    }

    // MARK: UIs

    private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    private(set) lazy var symbolLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.font = .systemFont(ofSize: 17, weight: .medium)
        return view
    }()

    private(set) lazy var cellStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, symbolLabel])
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
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
        nameLabel.text = currencyRate.name
        symbolLabel.text = currencyRate.symbol
    }

    private func setupLayout() {
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
