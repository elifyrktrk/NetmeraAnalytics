import UIKit
import NetmeraCore
import NetmeraNotificationCore
import NetmeraNotificationInbox

class InboxViewController: UIViewController {
    
    // MARK: - Properties
    // Step 1: Define the inbox manager
    var inboxManager: NetmeraInboxManager?
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No notifications yet"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInbox()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Inbox"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupInbox() {
        // Step 2: Create a filter for fetching inbox notifications
        let filter = NetmeraInboxFilter(
            status: .all,                          // Show all notifications
            pageSize: 10,                          // Number of notifications per page
            shouldIncludeExpiredObjects: true,     // Include expired notifications
            categories: nil                        // No category filter
        )
        
        // Initialize inbox manager
        inboxManager = Netmera.inboxManager(with: filter)
        
        // Step 3: Fetch Inbox
        fetchInboxNotifications()
    }
    
    private func fetchInboxNotifications() {
        inboxManager?.inbox { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                if let objects = self.inboxManager?.objects {
                    self.emptyStateLabel.isHidden = !objects.isEmpty
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch notifications: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension InboxViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxManager?.objects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let inboxManager = inboxManager {
            let notification = inboxManager.objects[indexPath.row]
            var content = cell.defaultContentConfiguration()
            print(notification)
//            content.text = notification.description
//            content.secondaryText = notification.description
            cell.contentConfiguration = content
            
//            // Add unread indicator
//            if notification.pushStatus != .read {
//                cell.accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8)).apply {
//                    $0.backgroundColor = .systemBlue
//                    $0.layer.cornerRadius = 4
//                }
//            } else {
//                cell.accessoryView = nil
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let inboxManager = inboxManager else { return }
        let notification = inboxManager.objects[indexPath.row]
        
        // Mark as read when tapped
//        inboxManager.updateStatus(.read, for: notification) { [weak self] result in
//            switch result {
//            case .success:
//                self?.tableView.reloadRows(at: [indexPath], with: .none)
//            case .failure(let error):
//                print("Failed to mark notification as read: \(error)")
//            }
//        }
    }
}

// MARK: - UIView Extension
private extension UIView {
    @discardableResult
    func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
} 
