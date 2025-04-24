import UIKit

class RealtimeViewController: UIViewController {
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let activeUsersCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activeUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "Active Users"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activeUsersCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1,234"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activeUsersTrendLabel: UILabel = {
        let label = UILabel()
        label.text = "+5.2% from yesterday"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let eventsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let eventsLabel: UILabel = {
        let label = UILabel()
        label.text = "Events in Last Hour"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let eventsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "2,456"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let eventsTrendLabel: UILabel = {
        let label = UILabel()
        label.text = "+12.3% from previous hour"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Realtime"
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Add refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Setup scroll view
        let scrollView = UIScrollView()
        scrollView.refreshControl = refreshControl
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Add stack view to scroll view
        scrollView.addSubview(stackView)
        
        // Add cards to stack view
        stackView.addArrangedSubview(activeUsersCard)
        stackView.addArrangedSubview(eventsCard)
        
        // Add labels to active users card
        activeUsersCard.addSubview(activeUsersLabel)
        activeUsersCard.addSubview(activeUsersCountLabel)
        activeUsersCard.addSubview(activeUsersTrendLabel)
        
        // Add labels to events card
        eventsCard.addSubview(eventsLabel)
        eventsCard.addSubview(eventsCountLabel)
        eventsCard.addSubview(eventsTrendLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            activeUsersCard.heightAnchor.constraint(equalToConstant: 120),
            eventsCard.heightAnchor.constraint(equalToConstant: 120),
            
            // Active Users Card constraints
            activeUsersLabel.topAnchor.constraint(equalTo: activeUsersCard.topAnchor, constant: 16),
            activeUsersLabel.leadingAnchor.constraint(equalTo: activeUsersCard.leadingAnchor, constant: 16),
            activeUsersLabel.trailingAnchor.constraint(equalTo: activeUsersCard.trailingAnchor, constant: -16),
            
            activeUsersCountLabel.topAnchor.constraint(equalTo: activeUsersLabel.bottomAnchor, constant: 8),
            activeUsersCountLabel.leadingAnchor.constraint(equalTo: activeUsersCard.leadingAnchor, constant: 16),
            activeUsersCountLabel.trailingAnchor.constraint(equalTo: activeUsersCard.trailingAnchor, constant: -16),
            
            activeUsersTrendLabel.topAnchor.constraint(equalTo: activeUsersCountLabel.bottomAnchor, constant: 4),
            activeUsersTrendLabel.leadingAnchor.constraint(equalTo: activeUsersCard.leadingAnchor, constant: 16),
            activeUsersTrendLabel.trailingAnchor.constraint(equalTo: activeUsersCard.trailingAnchor, constant: -16),
            
            // Events Card constraints
            eventsLabel.topAnchor.constraint(equalTo: eventsCard.topAnchor, constant: 16),
            eventsLabel.leadingAnchor.constraint(equalTo: eventsCard.leadingAnchor, constant: 16),
            eventsLabel.trailingAnchor.constraint(equalTo: eventsCard.trailingAnchor, constant: -16),
            
            eventsCountLabel.topAnchor.constraint(equalTo: eventsLabel.bottomAnchor, constant: 8),
            eventsCountLabel.leadingAnchor.constraint(equalTo: eventsCard.leadingAnchor, constant: 16),
            eventsCountLabel.trailingAnchor.constraint(equalTo: eventsCard.trailingAnchor, constant: -16),
            
            eventsTrendLabel.topAnchor.constraint(equalTo: eventsCountLabel.bottomAnchor, constant: 4),
            eventsTrendLabel.leadingAnchor.constraint(equalTo: eventsCard.leadingAnchor, constant: 16),
            eventsTrendLabel.trailingAnchor.constraint(equalTo: eventsCard.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        // Simulate data refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
} 