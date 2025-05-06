import UIKit
import NetmeraLocation
import CoreLocation
import NetmeraCore


class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
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
        label.text = NSLocalizedString("account", comment: "")
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
        label.text = NSLocalizedString("notifications", comment: "")
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
        label.text = NSLocalizedString("appearance", comment: "")
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
    
    private let privacyCard: UIView = {
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
    
    private let privacyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("privacy", comment: "")
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let privacyStack: UIStackView = {
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
        title = NSLocalizedString("settings_title", comment: "")
        locationManager.delegate = self // CLLocationManagerDelegate için
    }
    
    // MARK: - Setup Methods
    
    @objc private func menuButtonTapped() {
        // Find the container view controller and toggle the menu
        if let containerVC = navigationController?.parent as? ContainerViewController {
            containerVC.toggleMenu()
        }
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Configure the view to respect the safe area
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = true
        
        // Add scroll view to view
        view.addSubview(scrollView)
        
        // Add stack view to scroll view
        scrollView.addSubview(stackView)
        
        // Add cards to stack view
        stackView.addArrangedSubview(accountCard)
        stackView.addArrangedSubview(notificationsCard)
        stackView.addArrangedSubview(appearanceCard)
        stackView.addArrangedSubview(privacyCard)
        
        // Setup account card
        accountCard.addSubview(accountTitleLabel)
        accountCard.addSubview(accountStack)
        
        // Setup notifications card
        notificationsCard.addSubview(notificationsTitleLabel)
        notificationsCard.addSubview(notificationsStack)
        
        // Setup appearance card
        appearanceCard.addSubview(appearanceTitleLabel)
        appearanceCard.addSubview(appearanceStack)
        
        // Setup privacy card
        privacyCard.addSubview(privacyTitleLabel)
        privacyCard.addSubview(privacyStack)
        
        // Add account settings
        addSettingsToStack(accountStack, settings: [
            ("profile", NSLocalizedString("profile", comment: ""), NSLocalizedString("edit_profile", comment: "")),
            ("security", NSLocalizedString("security", comment: ""), NSLocalizedString("change_password", comment: "")),
            ("billing", NSLocalizedString("billing", comment: ""), NSLocalizedString("billing", comment: ""))
        ])
        
        // Add notification settings
        addSettingsToStack(notificationsStack, settings: [
            ("push_notifications", NSLocalizedString("push_notifications", comment: ""), NSLocalizedString("receive_push_notifications", comment: "")),
            ("email_notifications", NSLocalizedString("email_notifications", comment: ""), NSLocalizedString("receive_email_notifications", comment: "")),
            ("in_app_notifications", NSLocalizedString("in_app_notifications", comment: ""), NSLocalizedString("receive_in_app_notifications", comment: ""))
        ])
        
        // Add privacy settings
        addSettingsToStack(privacyStack, settings: [
            ("advertising_id", NSLocalizedString("advertising_id", comment: ""), NSLocalizedString("manage_advertising_id", comment: ""))
        ])
        
        // Add appearance settings
        addSettingsToStack(appearanceStack, settings: [
            ("theme", NSLocalizedString("theme", comment: ""), NSLocalizedString("light_dark_system", comment: "")),
            ("font_size", NSLocalizedString("font_size", comment: ""), NSLocalizedString("adjust_text_size", comment: "")),
            ("language", NSLocalizedString("language", comment: ""), Locale.current.localizedString(forIdentifier: Locale.current.languageCode ?? "en") ?? "English")
        ])
        
        // Add privacy settings
        addPrivacySettingsToStack(privacyStack, settings: [
            (NSLocalizedString("location_services", comment: ""), NSLocalizedString("allow_access_location", comment: ""), #selector(locationSettingsTapped))
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
            appearanceStack.bottomAnchor.constraint(equalTo: appearanceCard.bottomAnchor, constant: -16),
            
            // Privacy Card constraints
            privacyTitleLabel.topAnchor.constraint(equalTo: privacyCard.topAnchor, constant: 16),
            privacyTitleLabel.leadingAnchor.constraint(equalTo: privacyCard.leadingAnchor, constant: 16),
            privacyTitleLabel.trailingAnchor.constraint(equalTo: privacyCard.trailingAnchor, constant: -16),
            
            privacyStack.topAnchor.constraint(equalTo: privacyTitleLabel.bottomAnchor, constant: 16),
            privacyStack.leadingAnchor.constraint(equalTo: privacyCard.leadingAnchor, constant: 16),
            privacyStack.trailingAnchor.constraint(equalTo: privacyCard.trailingAnchor, constant: -16),
            privacyStack.bottomAnchor.constraint(equalTo: privacyCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func addSettingsToStack(_ stack: UIStackView, settings: [(key: String, title: String, description: String)]) {
        for setting in settings {
            let settingView = createSettingView(title: setting.title, description: setting.description)
            stack.addArrangedSubview(settingView)
            
            switch setting.key {
            case "push_notifications":
                settingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushNotificationsTapped)))
            case "email_notifications":
                settingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emailNotificationsTapped)))
            case "in_app_notifications":
                settingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inAppNotificationsTapped)))
            case "advertising_id":
                settingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(advertisingIDTapped)))
            case "language":
                settingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(languageTapped)))
            default:
                break
            }
        }
    }
    
    @objc private func pushNotificationsTapped() {
        let pushVC = PushNotificationsViewController()
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    @objc private func emailNotificationsTapped() {
        let emailVC = EmailNotificationsViewController()
        // Push to the current navigation controller if available
        if let navController = navigationController {
            navController.pushViewController(emailVC, animated: true)
        } else {
            // If no navigation controller, present modally with navigation
            let navVC = UINavigationController(rootViewController: emailVC)
            present(navVC, animated: true)
        }
    }
    
    @objc private func inAppNotificationsTapped() {
        let inAppVC = InAppNotificationsViewController()
        // Push to the current navigation controller if available
        if let navController = navigationController {
            navController.pushViewController(inAppVC, animated: true)
        } else {
            // If no navigation controller, present modally with navigation
            let navVC = UINavigationController(rootViewController: inAppVC)
            present(navVC, animated: true)
        }
    }
    
    @objc private func advertisingIDTapped() {
        let adIDVC = AdvertisingIDViewController()
        // Push to the current navigation controller if available
        if let navController = navigationController {
            navController.pushViewController(adIDVC, animated: true)
        } else {
            // If no navigation controller, present modally with navigation
            let navVC = UINavigationController(rootViewController: adIDVC)
            present(navVC, animated: true)
        }
    }
    
    @objc private func languageTapped() {
    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(appSettings)
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
    
    private func addPrivacySettingsToStack(_ stack: UIStackView, settings: [(title: String, description: String, action: Selector)]) {
        for setting in settings {
            let settingView = createPrivacySettingView(title: setting.title, description: setting.description, action: setting.action)
            stack.addArrangedSubview(settingView)
        }
    }
    
    private func createPrivacySettingView(title: String, description: String, action: Selector) -> UIView {
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
        
        let statusLabel = UILabel()
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Set initial status
        updateLocationStatusLabel(statusLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }
    
    private func updateLocationStatusLabel(_ label: UILabel) {
        // Native CoreLocation ile izin durumunu kontrol et
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            label.text = NSLocalizedString("allowed", comment: "")
            label.textColor = .systemGreen
        case .denied:
            label.text = NSLocalizedString("denied", comment: "")
            label.textColor = .systemRed
        case .restricted:
            label.text = NSLocalizedString("restricted", comment: "")
            label.textColor = .systemOrange
        case .notDetermined:
            label.text = NSLocalizedString("not_set", comment: "")
            label.textColor = .secondaryLabel
        @unknown default:
            label.text = NSLocalizedString("unknown", comment: "")
            label.textColor = .secondaryLabel
        }
    }
    
    // MARK: - Language Display Helper
    

    // MARK: - Actions
    @objc private func locationSettingsTapped() {
      
        Netmera.requestLocationAuthorization()
       
    }
    
    private func updateLocationStatusLabels() {
        // Tüm location status label'ları güncelle
        for case let view as UIView in privacyStack.arrangedSubviews {
            if let statusLabel = view.subviews.first(where: { subview in
                guard let label = subview as? UILabel, 
                      let text = label.text else { return false }
                return ["Allowed", "Denied", "Restricted", "Not Set"].contains(text)
            }) as? UILabel {
                updateLocationStatusLabel(statusLabel)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension SettingsViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // İzin durumu değiştiğinde UI'ı güncelle
        updateLocationStatusLabels()
    }
} 
