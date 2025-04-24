import UIKit

class LifecycleViewController: UIViewController {
    
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
    
    private let userAcquisitionCard: UIView = {
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
    
    private let userAcquisitionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Acquisition"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userAcquisitionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Track how users discover and install your app"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userAcquisitionMetricsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let userEngagementCard: UIView = {
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
    
    private let userEngagementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Engagement"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userEngagementDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Monitor how users interact with your app"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userEngagementMetricsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let userRetentionCard: UIView = {
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
    
    private let userRetentionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Retention"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userRetentionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Analyze how well you retain users over time"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userRetentionMetricsStack: UIStackView = {
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
        title = "Life Cycle"
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
        stackView.addArrangedSubview(userAcquisitionCard)
        stackView.addArrangedSubview(userEngagementCard)
        stackView.addArrangedSubview(userRetentionCard)
        
        // Setup user acquisition card
        userAcquisitionCard.addSubview(userAcquisitionTitleLabel)
        userAcquisitionCard.addSubview(userAcquisitionDescriptionLabel)
        userAcquisitionCard.addSubview(userAcquisitionMetricsStack)
        
        // Setup user engagement card
        userEngagementCard.addSubview(userEngagementTitleLabel)
        userEngagementCard.addSubview(userEngagementDescriptionLabel)
        userEngagementCard.addSubview(userEngagementMetricsStack)
        
        // Setup user retention card
        userRetentionCard.addSubview(userRetentionTitleLabel)
        userRetentionCard.addSubview(userRetentionDescriptionLabel)
        userRetentionCard.addSubview(userRetentionMetricsStack)
        
        // Add metrics to stacks
        addMetricsToStack(userAcquisitionMetricsStack, metrics: [
            ("New Users", "1,234", "+5.2%"),
            ("Installs", "1,567", "+8.1%"),
            ("Sources", "12", "+2")
        ])
        
        addMetricsToStack(userEngagementMetricsStack, metrics: [
            ("Active Users", "8,765", "+12.3%"),
            ("Session Duration", "8.5m", "+1.2m"),
            ("Events/User", "24", "+3")
        ])
        
        addMetricsToStack(userRetentionMetricsStack, metrics: [
            ("1-Day", "45%", "+5%"),
            ("7-Day", "28%", "+3%"),
            ("30-Day", "15%", "+2%")
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
            
            // User Acquisition Card constraints
            userAcquisitionTitleLabel.topAnchor.constraint(equalTo: userAcquisitionCard.topAnchor, constant: 16),
            userAcquisitionTitleLabel.leadingAnchor.constraint(equalTo: userAcquisitionCard.leadingAnchor, constant: 16),
            userAcquisitionTitleLabel.trailingAnchor.constraint(equalTo: userAcquisitionCard.trailingAnchor, constant: -16),
            
            userAcquisitionDescriptionLabel.topAnchor.constraint(equalTo: userAcquisitionTitleLabel.bottomAnchor, constant: 4),
            userAcquisitionDescriptionLabel.leadingAnchor.constraint(equalTo: userAcquisitionCard.leadingAnchor, constant: 16),
            userAcquisitionDescriptionLabel.trailingAnchor.constraint(equalTo: userAcquisitionCard.trailingAnchor, constant: -16),
            
            userAcquisitionMetricsStack.topAnchor.constraint(equalTo: userAcquisitionDescriptionLabel.bottomAnchor, constant: 16),
            userAcquisitionMetricsStack.leadingAnchor.constraint(equalTo: userAcquisitionCard.leadingAnchor, constant: 16),
            userAcquisitionMetricsStack.trailingAnchor.constraint(equalTo: userAcquisitionCard.trailingAnchor, constant: -16),
            userAcquisitionMetricsStack.bottomAnchor.constraint(equalTo: userAcquisitionCard.bottomAnchor, constant: -16),
            
            // User Engagement Card constraints
            userEngagementTitleLabel.topAnchor.constraint(equalTo: userEngagementCard.topAnchor, constant: 16),
            userEngagementTitleLabel.leadingAnchor.constraint(equalTo: userEngagementCard.leadingAnchor, constant: 16),
            userEngagementTitleLabel.trailingAnchor.constraint(equalTo: userEngagementCard.trailingAnchor, constant: -16),
            
            userEngagementDescriptionLabel.topAnchor.constraint(equalTo: userEngagementTitleLabel.bottomAnchor, constant: 4),
            userEngagementDescriptionLabel.leadingAnchor.constraint(equalTo: userEngagementCard.leadingAnchor, constant: 16),
            userEngagementDescriptionLabel.trailingAnchor.constraint(equalTo: userEngagementCard.trailingAnchor, constant: -16),
            
            userEngagementMetricsStack.topAnchor.constraint(equalTo: userEngagementDescriptionLabel.bottomAnchor, constant: 16),
            userEngagementMetricsStack.leadingAnchor.constraint(equalTo: userEngagementCard.leadingAnchor, constant: 16),
            userEngagementMetricsStack.trailingAnchor.constraint(equalTo: userEngagementCard.trailingAnchor, constant: -16),
            userEngagementMetricsStack.bottomAnchor.constraint(equalTo: userEngagementCard.bottomAnchor, constant: -16),
            
            // User Retention Card constraints
            userRetentionTitleLabel.topAnchor.constraint(equalTo: userRetentionCard.topAnchor, constant: 16),
            userRetentionTitleLabel.leadingAnchor.constraint(equalTo: userRetentionCard.leadingAnchor, constant: 16),
            userRetentionTitleLabel.trailingAnchor.constraint(equalTo: userRetentionCard.trailingAnchor, constant: -16),
            
            userRetentionDescriptionLabel.topAnchor.constraint(equalTo: userRetentionTitleLabel.bottomAnchor, constant: 4),
            userRetentionDescriptionLabel.leadingAnchor.constraint(equalTo: userRetentionCard.leadingAnchor, constant: 16),
            userRetentionDescriptionLabel.trailingAnchor.constraint(equalTo: userRetentionCard.trailingAnchor, constant: -16),
            
            userRetentionMetricsStack.topAnchor.constraint(equalTo: userRetentionDescriptionLabel.bottomAnchor, constant: 16),
            userRetentionMetricsStack.leadingAnchor.constraint(equalTo: userRetentionCard.leadingAnchor, constant: 16),
            userRetentionMetricsStack.trailingAnchor.constraint(equalTo: userRetentionCard.trailingAnchor, constant: -16),
            userRetentionMetricsStack.bottomAnchor.constraint(equalTo: userRetentionCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func addMetricsToStack(_ stack: UIStackView, metrics: [(title: String, value: String, trend: String)]) {
        for metric in metrics {
            let metricView = createMetricView(title: metric.title, value: metric.value, trend: metric.trend)
            stack.addArrangedSubview(metricView)
        }
    }
    
    private func createMetricView(title: String, value: String, trend: String) -> UIView {
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
        
        let trendLabel = UILabel()
        trendLabel.text = trend
        trendLabel.font = .systemFont(ofSize: 12)
        trendLabel.textColor = .systemGreen
        trendLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(valueLabel)
        view.addSubview(trendLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            trendLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            trendLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trendLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trendLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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