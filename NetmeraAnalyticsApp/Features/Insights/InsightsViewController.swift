import UIKit

class InsightsViewController: UIViewController {
    
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
        label.text = "Your app's 7-day retention rate is 45%, which is 12% higher than industry average."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userBehaviorCard: UIView = {
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
    
    private let userBehaviorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Behavior"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userBehaviorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Users spend an average of 8.5 minutes per session, with peak activity between 7-9 PM."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let conversionCard: UIView = {
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
    
    private let conversionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Conversion Insights"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let conversionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Push notifications increase conversion by 28%. Users who receive 2-3 notifications per week have the highest engagement."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Insights"
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
        stackView.addArrangedSubview(userRetentionCard)
        stackView.addArrangedSubview(userBehaviorCard)
        stackView.addArrangedSubview(conversionCard)
        
        // Add labels to user retention card
        userRetentionCard.addSubview(userRetentionTitleLabel)
        userRetentionCard.addSubview(userRetentionDescriptionLabel)
        
        // Add labels to user behavior card
        userBehaviorCard.addSubview(userBehaviorTitleLabel)
        userBehaviorCard.addSubview(userBehaviorDescriptionLabel)
        
        // Add labels to conversion card
        conversionCard.addSubview(conversionTitleLabel)
        conversionCard.addSubview(conversionDescriptionLabel)
        
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
            
            // User Retention Card constraints
            userRetentionTitleLabel.topAnchor.constraint(equalTo: userRetentionCard.topAnchor, constant: 16),
            userRetentionTitleLabel.leadingAnchor.constraint(equalTo: userRetentionCard.leadingAnchor, constant: 16),
            userRetentionTitleLabel.trailingAnchor.constraint(equalTo: userRetentionCard.trailingAnchor, constant: -16),
            
            userRetentionDescriptionLabel.topAnchor.constraint(equalTo: userRetentionTitleLabel.bottomAnchor, constant: 8),
            userRetentionDescriptionLabel.leadingAnchor.constraint(equalTo: userRetentionCard.leadingAnchor, constant: 16),
            userRetentionDescriptionLabel.trailingAnchor.constraint(equalTo: userRetentionCard.trailingAnchor, constant: -16),
            userRetentionDescriptionLabel.bottomAnchor.constraint(equalTo: userRetentionCard.bottomAnchor, constant: -16),
            
            // User Behavior Card constraints
            userBehaviorTitleLabel.topAnchor.constraint(equalTo: userBehaviorCard.topAnchor, constant: 16),
            userBehaviorTitleLabel.leadingAnchor.constraint(equalTo: userBehaviorCard.leadingAnchor, constant: 16),
            userBehaviorTitleLabel.trailingAnchor.constraint(equalTo: userBehaviorCard.trailingAnchor, constant: -16),
            
            userBehaviorDescriptionLabel.topAnchor.constraint(equalTo: userBehaviorTitleLabel.bottomAnchor, constant: 8),
            userBehaviorDescriptionLabel.leadingAnchor.constraint(equalTo: userBehaviorCard.leadingAnchor, constant: 16),
            userBehaviorDescriptionLabel.trailingAnchor.constraint(equalTo: userBehaviorCard.trailingAnchor, constant: -16),
            userBehaviorDescriptionLabel.bottomAnchor.constraint(equalTo: userBehaviorCard.bottomAnchor, constant: -16),
            
            // Conversion Card constraints
            conversionTitleLabel.topAnchor.constraint(equalTo: conversionCard.topAnchor, constant: 16),
            conversionTitleLabel.leadingAnchor.constraint(equalTo: conversionCard.leadingAnchor, constant: 16),
            conversionTitleLabel.trailingAnchor.constraint(equalTo: conversionCard.trailingAnchor, constant: -16),
            
            conversionDescriptionLabel.topAnchor.constraint(equalTo: conversionTitleLabel.bottomAnchor, constant: 8),
            conversionDescriptionLabel.leadingAnchor.constraint(equalTo: conversionCard.leadingAnchor, constant: 16),
            conversionDescriptionLabel.trailingAnchor.constraint(equalTo: conversionCard.trailingAnchor, constant: -16),
            conversionDescriptionLabel.bottomAnchor.constraint(equalTo: conversionCard.bottomAnchor, constant: -16)
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