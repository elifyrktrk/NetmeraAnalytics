import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    private var sections: [DashboardSection] = []
    
    // MARK: - UI Components
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
        setupNavigationBar()
        configureSections()
        setupRefreshControl()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Analytics Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let logoutButton = UIBarButtonItem(title: "Logout",
                                         style: .plain,
                                         target: self,
                                         action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = logoutButton
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
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout",
                                    message: "Are you sure you want to logout?",
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                // Navigate back to login
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self?.present(loginVC, animated: true)
            } catch {
                self?.showAlert(title: "Error", message: "Failed to logout. Please try again.")
            }
        })
        
        present(alert, animated: true)
    }
    
    @objc private func refreshData() {
        // Simulate data refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.configureSections()
            self?.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
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
