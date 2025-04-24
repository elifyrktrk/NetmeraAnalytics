import UIKit

class SettingsViewController: UIViewController {
    
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
    
    private let accountCard: UIView = {
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
    
    private let accountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Account"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let accountStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let notificationsCard: UIView = {
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
    
    private let notificationsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notificationsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let appearanceCard: UIView = {
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
    
    private let appearanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Appearance"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appearanceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Settings"
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Setup scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Add stack view to scroll view
        scrollView.addSubview(stackView)
        
        // Add cards to stack view
        stackView.addArrangedSubview(accountCard)
        stackView.addArrangedSubview(notificationsCard)
        stackView.addArrangedSubview(appearanceCard)
        
        // Setup account card
        accountCard.addSubview(accountTitleLabel)
        accountCard.addSubview(accountStack)
        
        // Setup notifications card
        notificationsCard.addSubview(notificationsTitleLabel)
        notificationsCard.addSubview(notificationsStack)
        
        // Setup appearance card
        appearanceCard.addSubview(appearanceTitleLabel)
        appearanceCard.addSubview(appearanceStack)
        
        // Add account settings
        addSettingsToStack(accountStack, settings: [
            ("Profile", "Edit your profile information"),
            ("Security", "Change password and security settings"),
            ("Billing", "Manage subscription and billing")
        ])
        
        // Add notification settings
        addSettingsToStack(notificationsStack, settings: [
            ("Push Notifications", "Receive push notifications"),
            ("Email Notifications", "Receive email notifications"),
            ("In-App Notifications", "Receive in-app notifications")
        ])
        
        // Add appearance settings
        addSettingsToStack(appearanceStack, settings: [
            ("Theme", "Light / Dark / System"),
            ("Font Size", "Adjust text size"),
            ("Language", "English")
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
            
            // Account Card constraints
            accountTitleLabel.topAnchor.constraint(equalTo: accountCard.topAnchor, constant: 16),
            accountTitleLabel.leadingAnchor.constraint(equalTo: accountCard.leadingAnchor, constant: 16),
            accountTitleLabel.trailingAnchor.constraint(equalTo: accountCard.trailingAnchor, constant: -16),
            
            accountStack.topAnchor.constraint(equalTo: accountTitleLabel.bottomAnchor, constant: 16),
            accountStack.leadingAnchor.constraint(equalTo: accountCard.leadingAnchor, constant: 16),
            accountStack.trailingAnchor.constraint(equalTo: accountCard.trailingAnchor, constant: -16),
            accountStack.bottomAnchor.constraint(equalTo: accountCard.bottomAnchor, constant: -16),
            
            // Notifications Card constraints
            notificationsTitleLabel.topAnchor.constraint(equalTo: notificationsCard.topAnchor, constant: 16),
            notificationsTitleLabel.leadingAnchor.constraint(equalTo: notificationsCard.leadingAnchor, constant: 16),
            notificationsTitleLabel.trailingAnchor.constraint(equalTo: notificationsCard.trailingAnchor, constant: -16),
            
            notificationsStack.topAnchor.constraint(equalTo: notificationsTitleLabel.bottomAnchor, constant: 16),
            notificationsStack.leadingAnchor.constraint(equalTo: notificationsCard.leadingAnchor, constant: 16),
            notificationsStack.trailingAnchor.constraint(equalTo: notificationsCard.trailingAnchor, constant: -16),
            notificationsStack.bottomAnchor.constraint(equalTo: notificationsCard.bottomAnchor, constant: -16),
            
            // Appearance Card constraints
            appearanceTitleLabel.topAnchor.constraint(equalTo: appearanceCard.topAnchor, constant: 16),
            appearanceTitleLabel.leadingAnchor.constraint(equalTo: appearanceCard.leadingAnchor, constant: 16),
            appearanceTitleLabel.trailingAnchor.constraint(equalTo: appearanceCard.trailingAnchor, constant: -16),
            
            appearanceStack.topAnchor.constraint(equalTo: appearanceTitleLabel.bottomAnchor, constant: 16),
            appearanceStack.leadingAnchor.constraint(equalTo: appearanceCard.leadingAnchor, constant: 16),
            appearanceStack.trailingAnchor.constraint(equalTo: appearanceCard.trailingAnchor, constant: -16),
            appearanceStack.bottomAnchor.constraint(equalTo: appearanceCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func addSettingsToStack(_ stack: UIStackView, settings: [(title: String, description: String)]) {
        for setting in settings {
            let settingView = createSettingView(title: setting.title, description: setting.description)
            stack.addArrangedSubview(settingView)
        }
    }
    
    private func createSettingView(title: String, description: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .secondaryLabel
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            chevronImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return view
    }
} 