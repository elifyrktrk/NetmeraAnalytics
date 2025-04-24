import UIKit

class UserViewController: UIViewController {
    
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
    
    private let userProfileCard: UIView = {
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
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Doe"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "john.doe@example.com"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userStatsCard: UIView = {
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
    
    private let userStatsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "User"
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
        stackView.addArrangedSubview(userProfileCard)
        stackView.addArrangedSubview(userStatsCard)
        
        // Setup user profile card
        userProfileCard.addSubview(userProfileImageView)
        userProfileCard.addSubview(userNameLabel)
        userProfileCard.addSubview(userEmailLabel)
        
        // Setup user stats card
        userStatsCard.addSubview(userStatsStack)
        
        // Add metrics to stats stack
        addMetricsToStack(userStatsStack, metrics: [
            ("Total Events", "1,234", "+5.2%"),
            ("Sessions", "567", "+8.1%"),
            ("Last Active", "2h ago", nil)
        ])
        
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
            
            // User Profile Card constraints
            userProfileImageView.topAnchor.constraint(equalTo: userProfileCard.topAnchor, constant: 16),
            userProfileImageView.centerXAnchor.constraint(equalTo: userProfileCard.centerXAnchor),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 80),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            userNameLabel.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 16),
            userNameLabel.centerXAnchor.constraint(equalTo: userProfileCard.centerXAnchor),
            
            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            userEmailLabel.centerXAnchor.constraint(equalTo: userProfileCard.centerXAnchor),
            userEmailLabel.bottomAnchor.constraint(equalTo: userProfileCard.bottomAnchor, constant: -16),
            
            // User Stats Card constraints
            userStatsStack.topAnchor.constraint(equalTo: userStatsCard.topAnchor, constant: 16),
            userStatsStack.leadingAnchor.constraint(equalTo: userStatsCard.leadingAnchor, constant: 16),
            userStatsStack.trailingAnchor.constraint(equalTo: userStatsCard.trailingAnchor, constant: -16),
            userStatsStack.bottomAnchor.constraint(equalTo: userStatsCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func addMetricsToStack(_ stack: UIStackView, metrics: [(title: String, value: String, trend: String?)]) {
        for metric in metrics {
            let metricView = createMetricView(title: metric.title, value: metric.value, trend: metric.trend)
            stack.addArrangedSubview(metricView)
        }
    }
    
    private func createMetricView(title: String, value: String, trend: String?) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let trend = trend {
            let trendLabel = UILabel()
            trendLabel.text = trend
            trendLabel.font = .systemFont(ofSize: 12)
            trendLabel.textColor = .systemGreen
            trendLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(trendLabel)
            
            NSLayoutConstraint.activate([
                trendLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
                trendLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trendLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                trendLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        return view
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        // Simulate data refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
} 