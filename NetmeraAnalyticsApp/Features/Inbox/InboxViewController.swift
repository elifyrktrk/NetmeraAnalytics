import UIKit
import NetmeraNotificationCore
import NetmeraNotificationInbox
import NetmeraCore


class InboxViewController: UIViewController {

    private var inboxManager: NetmeraInboxManager?
    private let tableView = UITableView()
    private var pushObjects: [NetmeraInboxPush] = []
    
    // Kategori butonları için eklenenler
    private let categories = ["All", "Unread", "Feature Announcement", "Milestones", "SDK News"]
    // Kategori adlarının Netmera'daki karşılıkları
    private let categoryKeys = [nil, nil, "feature_announcement", "milestone", "sdk_news"]
    private var selectedCategoryIndex = 0
    private let categoryScrollView = UIScrollView()
    private let categoryStackView = UIStackView()
    private var categoryButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inbox"
        view.backgroundColor = .systemBackground
        
        // Add close button to navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(closeTapped))
        
        setupCategoryBar()
        setupTableView()
        fetchInbox()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    private func setupCategoryBar() {
        categoryScrollView.showsHorizontalScrollIndicator = false
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryScrollView)

        categoryStackView.axis = .horizontal
        categoryStackView.alignment = .fill
        categoryStackView.spacing = 12
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false
        categoryScrollView.addSubview(categoryStackView)

        for (index, title) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.backgroundColor = (index == selectedCategoryIndex) ? UIColor.systemTeal : UIColor.systemGray6
            button.setTitleColor((index == selectedCategoryIndex) ? .white : .label, for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.tag = index
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            categoryStackView.addArrangedSubview(button)
            categoryButtons.append(button)
        }

        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 44),

            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 12),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -12),
            categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor)
        ])
    }

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        selectedCategoryIndex = sender.tag
        updateCategoryButtonUI()
        fetchInbox()
    }

    private func updateCategoryButtonUI() {
        for (index, button) in categoryButtons.enumerated() {
            button.backgroundColor = (index == selectedCategoryIndex) ? UIColor.systemTeal : UIColor.systemGray6
            button.setTitleColor((index == selectedCategoryIndex) ? .white : .label, for: .normal)
        }
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
            tableView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchInbox() {
        let status: NetmeraInboxStatus = (selectedCategoryIndex == 1) ? .unread : .all
        let selectedCategory = categoryKeys[selectedCategoryIndex]
        print("[DEBUG] Selected category index: \(selectedCategoryIndex), key: \(String(describing: selectedCategory)), status: \(status)")
        let filter = NetmeraInboxFilter(
            status: status,
            pageSize: 20,
            shouldIncludeExpiredObjects: true,
            categories: selectedCategory != nil ? [selectedCategory!] : nil
        )
        print("[DEBUG] NetmeraInboxFilter: status=\(filter.status), pageSize=\(filter.pageSize), shouldIncludeExpiredObjects=\(filter.shouldIncludeExpiredObjects), categories=\(String(describing: filter.categories))")
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

