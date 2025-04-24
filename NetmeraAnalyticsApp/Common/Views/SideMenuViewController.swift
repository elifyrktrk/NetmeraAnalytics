import UIKit

protocol SideMenuDelegate: AnyObject {
    func didSelectMenuItem(title: String)
}

class SideMenuViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: SideMenuDelegate?
    
    private let menuItems: [[MenuItem]] = [
        [
            MenuItem(icon: "house", title: "Home", isSelected: true),
            MenuItem(icon: "clock", title: "Realtime"),
            MenuItem(icon: "square.grid.2x2", title: "Dashboard"),
            MenuItem(icon: "chart.line.uptrend.xyaxis", title: "Insights")
        ],
        [
            MenuItem(icon: "chart.bar", title: "Reports snapshot"),
            MenuItem(icon: "arrow.triangle.2.circlepath", title: "Life cycle"),
            MenuItem(icon: "person", title: "User")
        ],
        [
            MenuItem(icon: "testtube.2", title: "Test Netmera"),
            MenuItem(icon: "questionmark.circle", title: "Help"),
            MenuItem(icon: "bubble.left", title: "Feedback"),
            MenuItem(icon: "gearshape", title: "Settings")
        ]
    ]
    
    private var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private let sectionTitles = ["", "REPORTS", ""]
    
    // MARK: - UI Components
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chart.bar.fill")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Netmera Analytics"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let accountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Account for Netmera"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let projectLabel: UILabel = {
        let label = UILabel()
        label.text = "netmeraanalyticsapp"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.rowHeight = 44
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.addSubview(appIconImageView)
        headerView.addSubview(appNameLabel)
        
        view.addSubview(accountView)
        accountView.addSubview(accountLabel)
        accountView.addSubview(projectLabel)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            appIconImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            appIconImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            appIconImageView.widthAnchor.constraint(equalToConstant: 30),
            appIconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            appNameLabel.leadingAnchor.constraint(equalTo: appIconImageView.trailingAnchor, constant: 12),
            appNameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            accountView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            accountView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accountView.heightAnchor.constraint(equalToConstant: 80),
            
            accountLabel.topAnchor.constraint(equalTo: accountView.topAnchor, constant: 16),
            accountLabel.leadingAnchor.constraint(equalTo: accountView.leadingAnchor, constant: 16),
            accountLabel.trailingAnchor.constraint(equalTo: accountView.trailingAnchor, constant: -16),
            
            projectLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 4),
            projectLabel.leadingAnchor.constraint(equalTo: accountView.leadingAnchor, constant: 16),
            projectLabel.trailingAnchor.constraint(equalTo: accountView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: accountView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate & DataSource
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier, for: indexPath) as? MenuItemCell else {
            return UITableViewCell()
        }
        
        let item = menuItems[indexPath.section][indexPath.row]
        let isSelected = selectedIndexPath == indexPath
        cell.configure(with: MenuItem(icon: item.icon, title: item.title, isSelected: isSelected))
        return cell

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Update selection
        let oldIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        
        // Refresh cells
        tableView.reloadRows(at: [oldIndexPath, selectedIndexPath], with: .none)
        
        // Notify delegate
        let selectedItem = menuItems[indexPath.section][indexPath.row]
        delegate?.didSelectMenuItem(title: selectedItem.title)
    }
}

// MARK: - Supporting Types
struct MenuItem {
    let icon: String
    let title: String
    var isSelected: Bool = false
}

// MARK: - MenuItemCell
class MenuItemCell: UITableViewCell {
    static let identifier = "MenuItemCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with item: MenuItem) {
        iconImageView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        
        if item.isSelected {
            backgroundColor = .systemBlue.withAlphaComponent(0.1)
            titleLabel.textColor = .systemBlue
            iconImageView.tintColor = .systemBlue
        } else {
            backgroundColor = .white
            titleLabel.textColor = .label
            iconImageView.tintColor = .label
        }
    }
} 
