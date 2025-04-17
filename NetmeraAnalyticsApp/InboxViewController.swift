import UIKit
import NetmeraNotificationCore
import NetmeraNotificationInbox
import NetmeraCore


class InboxViewController: UIViewController {

    private var inboxManager: NetmeraInboxManager?
    private let tableView = UITableView()
    private var pushObjects: [NetmeraInboxPush] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inbox"
        view.backgroundColor = .systemBackground
        setupTableView()
        fetchInbox()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InboxCell.self, forCellReuseIdentifier: InboxCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchInbox() {
        let filter = NetmeraInboxFilter(status: .all, pageSize: 20, shouldIncludeExpiredObjects: true, categories: nil)
        inboxManager = Netmera.inboxManager(with: filter)

        inboxManager?.inbox { [weak self] result in
            switch result {
            case .success:
                if let objects = self?.inboxManager?.objects as? [NetmeraInboxPush] {
                    self?.pushObjects = objects
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Failed to fetch inbox: \(error.description)")
            }
        }
    }
}

extension InboxViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pushObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InboxCell.identifier, for: indexPath) as! InboxCell
        cell.configure(with: pushObjects[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let push = pushObjects[indexPath.row].push
        if let push = push {
            Netmera.handlePushObject(push)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//import UIKit
//import NetmeraCore
//import NetmeraNotificationCore
//import NetmeraNotificationInbox
//import SafariServices
//
//class InboxViewController: UIViewController {
//    
//    // MARK: - Properties
//    var inboxManager: NetmeraInboxManager?
//    private var notifications: [InboxNotification] = []
//    
//    // MARK: - UI Components
//    private lazy var tableView: UITableView = {
//        let table = UITableView()
//        table.delegate = self
//        table.dataSource = self
//        table.register(InboxCell.self, forCellReuseIdentifier: InboxCell.identifier)
//        table.backgroundColor = .systemBackground
//        table.separatorStyle = .none
//        table.translatesAutoresizingMaskIntoConstraints = false
//        return table
//    }()
//    
//    private let emptyStateView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let emptyStateImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "bell.slash")
//        imageView.tintColor = .tertiaryLabel
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    private let emptyStateLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No notifications yet"
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 16)
//        label.textColor = .secondaryLabel
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let refreshControl = UIRefreshControl()
//    
//    // MARK: - Lifecycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("InboxViewController - viewDidLoad")
//        setupUI()
//        setupInbox()
//        setupRefreshControl()
//    }
//    
//    // MARK: - Setup Methods
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        title = "Inbox"
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "xmark"),
//            style: .plain,
//            target: self,
//            action: #selector(closeTapped)
//        )
//        
//        // Setup empty state view
//        view.addSubview(emptyStateView)
//        emptyStateView.addSubview(emptyStateImageView)
//        emptyStateView.addSubview(emptyStateLabel)
//        
//        // Setup table view
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            emptyStateView.widthAnchor.constraint(equalToConstant: 200),
//            emptyStateView.heightAnchor.constraint(equalToConstant: 200),
//            
//            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
//            emptyStateImageView.bottomAnchor.constraint(equalTo: emptyStateLabel.topAnchor, constant: -16),
//            emptyStateImageView.widthAnchor.constraint(equalToConstant: 60),
//            emptyStateImageView.heightAnchor.constraint(equalToConstant: 60),
//            
//            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
//            emptyStateLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: 20)
//        ])
//    }
//    
//    private func setupInbox() {
//        print("Setting up inbox manager...")
//        let filter = NetmeraInboxFilter(
//            status: .all,
//            pageSize: 50,
//            shouldIncludeExpiredObjects: true,
//            categories: nil
//        )
//        
//        self.inboxManager = Netmera.inboxManager(with: filter)
//        print("Inbox manager created:", inboxManager != nil ? "success" : "failed")
//        fetchInboxNotifications()
//    }
//    
//    private func setupRefreshControl() {
//        refreshControl.addTarget(self, action: #selector(refreshInbox), for: .valueChanged)
//        tableView.refreshControl = refreshControl
//    }
//    
//    private func fetchInboxNotifications() {
//        print("Fetching inbox notifications...")
//        inboxManager?.inbox { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success:
//                print("Fetch success")
//                if let objects = self.inboxManager?.objects {
//                    print("Number of raw objects:", objects.count)
//                    
//                    // Convert objects to our model
//                    self.notifications = objects.compactMap { notification in
//                        if let pushNotification = notification as? NetmeraInboxPush {
//                            print("Converting NetmeraInboxPush notification")
//                            return InboxNotification(from: pushNotification)
//                        }
//                        print("Failed to convert notification to NetmeraInboxPush:", notification)
//                        return nil
//                    }
//                    
//                    print("Converted notifications count:", self.notifications.count)
//                    
//                    // Update UI
//                    DispatchQueue.main.async {
//                        print("Updating UI with notifications")
//                        self.emptyStateView.isHidden = !self.notifications.isEmpty
//                        self.tableView.reloadData()
//                        self.refreshControl.endRefreshing()
//                    }
//                } else {
//                    print("No objects found in inbox manager")
//                }
//            case .failure(let error):
//                print("Failed to fetch notifications: \(error)")
//                DispatchQueue.main.async {
//                    self.refreshControl.endRefreshing()
//                    // Show empty state
//                    self.emptyStateView.isHidden = false
//                }
//            }
//        }
//    }
//    
//    @objc private func refreshInbox() {
//        fetchInboxNotifications()
//    }
//    
//    @objc private func closeTapped() {
//        dismiss(animated: true)
//    }
//    
//    private func handleDeeplink(_ url: URL) {
//        let safariVC = SFSafariViewController(url: url)
//        present(safariVC, animated: true)
//    }
//}
//
//// MARK: - UITableViewDelegate & DataSource
//extension InboxViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("numberOfRowsInSection called, count:", notifications.count)
//        return notifications.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("Configuring cell at index:", indexPath.row)
//        let cell = tableView.dequeueReusableCell(withIdentifier: InboxCell.identifier, for: indexPath) as! InboxCell
//        let notification = notifications[indexPath.row]
//        print("Cell notification - Title:", notification.title, "Body:", notification.body)
//        cell.configure(with: notification)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let notification = notifications[indexPath.row]
//        if let url = notification.deeplinkURL {
//            handleDeeplink(url)
//        }
//    }
//}
//
//// MARK: - UIView Extension
//private extension UIView {
//    @discardableResult
//    func apply(_ closure: (Self) -> Void) -> Self {
//        closure(self)
//        return self
//    }
//} 
