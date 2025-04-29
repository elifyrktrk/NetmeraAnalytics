import UIKit
import NetmeraCore
class EmailNotificationsViewController: UIViewController {
    
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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emailToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Notifications"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Receive notifications via email"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dailyDigestToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let dailyDigestLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Digest"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dailyDigestDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Receive a daily summary of notifications"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        
        // Initialize email toggle state based on Netmera's current preference
        emailToggle.isOn = Netmera.isAllowedEmailSubscription()
        updateEmailStatus()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Email Notifications"
        
        // Add scroll view to view
        view.addSubview(scrollView)
        
        // Add content view to scroll view
        scrollView.addSubview(contentView)
        
        // Add stack view to content view
        contentView.addSubview(stackView)
        
        // Create email notifications section
        let emailSection = createSection(title: "Email Notifications", toggle: emailToggle, description: emailDescriptionLabel.text ?? "")
        
        // Create daily digest section
        let dailyDigestSection = createSection(title: "Daily Digest", toggle: dailyDigestToggle, description: dailyDigestDescriptionLabel.text ?? "")
        
        // Add sections to stack view
        stackView.addArrangedSubview(emailSection)
        stackView.addArrangedSubview(dailyDigestSection)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Stack view constraints
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        emailToggle.addTarget(self, action: #selector(emailToggleChanged), for: .valueChanged)
        dailyDigestToggle.addTarget(self, action: #selector(dailyDigestToggleChanged), for: .valueChanged)
    }
    
    // MARK: - Helper Methods
    private func createSection(title: String, toggle: UISwitch, description: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -16),
            
            toggle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            view.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16)
        ])
        
        return view
    }
    
    // MARK: - Actions
    @objc private func emailToggleChanged(_ sender: UISwitch) {
        // Update Netmera email subscription preference
        Netmera.setAllowedEmailSubscription(sender.isOn)
        
        // Update UI
        updateEmailStatus()
        
        // Log the change
        print("Email notifications toggled: \(sender.isOn)")
    }
    
    @objc private func dailyDigestToggleChanged(_ sender: UISwitch) {
        // Handle daily digest toggle change
        print("Daily digest toggled: \(sender.isOn)")
    }
    
    // MARK: - Private Methods
    private func updateEmailStatus() {
        // Update the status label with current email subscription status
        let status = Netmera.isAllowedEmailSubscription() ? "Enabled" : "Disabled"
        emailDescriptionLabel.text = "Email notifications are currently \(status)"
    }
}
