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
        
        // Add close button to navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(closeTapped))
        
        setupTableView()
        fetchInbox()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
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

    // Add deinit for crash fix
    deinit {
        // Attempt to explicitly release the inbox manager
        // Ideally, there would be a cancel method like inboxManager?.cancelFetch()
        inboxManager = nil
        print("InboxViewController deinitialized") // For debugging
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

