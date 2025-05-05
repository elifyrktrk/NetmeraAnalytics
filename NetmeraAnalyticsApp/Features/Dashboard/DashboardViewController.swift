import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    private var sections: [DashboardSection] = []
    
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Try \"Users last week\""
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.tintColor = .label
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear // Clear background to see taps
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let inboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.dataSource = self
        cv.register(MetricCell.self, forCellWithReuseIdentifier: MetricCell.identifier)
        cv.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.identifier)
        cv.register(HeaderView.self, 
                   forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                   withReuseIdentifier: HeaderView.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        loadDashboardData()
        setupButtonActions()
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Add refresh control
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func loadDashboardData() {
        // Call configureSections to load initial data
        configureSections()
    }
    
    private func setupButtonActions() {
        // Set up button actions
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        inboxButton.addTarget(self, action: #selector(inboxButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Configure navigation bar
        title = "Netmera Analytics"
        
        // Add top stack view
        view.addSubview(topStackView)
        
        // Configure menu button
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        // Hide the default navigation bar since we're using a custom one
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add buttons to stack view
        topStackView.addArrangedSubview(menuButton)
        topStackView.addArrangedSubview(searchBar)
        topStackView.addArrangedSubview(inboxButton)
        topStackView.addArrangedSubview(profileButton)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            menuButton.widthAnchor.constraint(equalToConstant: 44),
            menuButton.heightAnchor.constraint(equalToConstant: 44),
            
            inboxButton.widthAnchor.constraint(equalToConstant: 44),
            inboxButton.heightAnchor.constraint(equalToConstant: 44),
            
            profileButton.widthAnchor.constraint(equalToConstant: 44),
            profileButton.heightAnchor.constraint(equalToConstant: 44),
            
            collectionView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Configure button interactions
        menuButton.isUserInteractionEnabled = true
        inboxButton.addTarget(self, action: #selector(inboxButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func configureSections() {
        sections = [
            DashboardSection(title: "Real-Time Users", items: [
                .metric(MetricItem(title: "Active Users", value: "1,234", trend: .up(percentage: 5.2))),
                .metric(MetricItem(title: "Session Duration", value: "12m 30s", trend: .down(percentage: 2.1)))
            ]),
            DashboardSection(title: "User Activity", items: [
                .chart(title: "Daily Active Users", data: [65, 72, 86, 93, 85, 103, 98])
            ]),
            DashboardSection(title: "Event Analytics", items: [
                .metric(MetricItem(title: "Total Events", value: "45.2K", trend: .up(percentage: 8.7))),
                .metric(MetricItem(title: "Unique Events", value: "12.8K", trend: .up(percentage: 3.4)))
            ]),
            DashboardSection(title: "Event Trends", items: [
                .chart(title: "Events per Hour", data: [42, 38, 35, 30, 45, 55, 60, 48])
            ]),
            DashboardSection(title: "Push Notifications", items: [
                .metric(MetricItem(title: "Delivery Rate", value: "98.5%", trend: .up(percentage: 1.2))),
                .metric(MetricItem(title: "Open Rate", value: "24.3%", trend: .down(percentage: 0.8)))
            ]),
            DashboardSection(title: "Notification Performance", items: [
                .chart(title: "Weekly Open Rates", data: [22, 25, 23, 28, 24, 29, 26])
            ])
        ]
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func menuButtonTapped() {
        print("Menu button tapped!")
        // Look for ContainerViewController in the view hierarchy
        var current = parent
        while current != nil {
            if let containerVC = current as? ContainerViewController {
                print("ContainerVC found, toggling menu")
                containerVC.toggleMenu()
                return
            }
            current = current?.parent
        }
        print("ContainerVC not found! Parent hierarchy: \(String(describing: parent))")
    }
    
    @objc private func inboxButtonTapped() {
        let inboxVC = InboxViewController()
        let navigationController = UINavigationController(rootViewController: inboxVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc private func profileButtonTapped() {
        let profileVC = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc private func refreshData() {
        // Simulate data refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.configureSections()
            self?.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Helper Methods
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSection()
        }
        return layout
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        // Item
        let metricItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1.0))
        let metricItem = NSCollectionLayoutItem(layoutSize: metricItemSize)
        metricItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let chartItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .absolute(200))
        let chartItem = NSCollectionLayoutItem(layoutSize: chartItemSize)
        chartItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        // Group
        let metricsGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(120))
        let metricsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: metricsGroupSize,
                                                            subitems: [metricItem])
        
        let chartGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(200))
        let chartGroup = NSCollectionLayoutGroup.horizontal(layoutSize: chartGroupSize,
                                                          subitems: [chartItem])
        
        // Section
        let section = NSCollectionLayoutSection(group: metricsGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8)
        
        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

// MARK: - UICollectionViewDataSource
extension DashboardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.item]
        
        switch item {
        case .metric(let metricItem):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCell.identifier,
                                                              for: indexPath) as? MetricCell else {
                fatalError("Failed to dequeue MetricCell")
            }
            cell.configure(with: metricItem)
            return cell
            
        case .chart(let title, let data):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.identifier,
                                                              for: indexPath) as? ChartCell else {
                fatalError("Failed to dequeue ChartCell")
            }
            cell.configure(with: title, data: data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.identifier,
                for: indexPath) as? HeaderView else {
            fatalError("Failed to dequeue HeaderView")
        }
        
        header.configure(with: sections[indexPath.section].title)
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell selection - can navigate to detailed view
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Models
enum DashboardItemType {
    case metric(MetricItem)
    case chart(title: String, data: [CGFloat])
}

struct DashboardSection {
    let title: String
    let items: [DashboardItemType]
}

struct MetricItem {
    let title: String
    let value: String
    let trend: MetricTrend
}

enum MetricTrend {
    case up(percentage: Double)
    case down(percentage: Double)
} 
