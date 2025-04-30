import UIKit
import NetmeraCore

class InAppNotificationsViewController: UIViewController {
    
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
    
    private let popupSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    private let bannerSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    private let popupLabel: UILabel = {
        let label = UILabel()
        label.text = "Popup & Widget Push"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bannerLabel: UILabel = {
        let label = UILabel()
        label.text = "Banner Push"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popupDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Receive popup and widget notifications"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bannerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Receive banner notifications"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupSwitches()
        setupMenu()
        title = "In-App Notifications"
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Add close button to navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(closeTapped))
        
        // Add menu button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        // Add scroll view to view
        view.addSubview(scrollView)
        
        // Add content view to scroll view
        scrollView.addSubview(contentView)
        
        // Add stack view to content view
        contentView.addSubview(stackView)
        
        // Create popup section
        let popupSection = createSection(title: "Popup & Widget Push", toggle: popupSwitch, description: popupDescriptionLabel.text ?? "")
        let bannerSection = createSection(title: "Banner Push", toggle: bannerSwitch, description: bannerDescriptionLabel.text ?? "")
        
        // Add sections to stack
        stackView.addArrangedSubview(popupSection)
        stackView.addArrangedSubview(bannerSection)
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
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Description constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -16),
            
            // Toggle constraints
            toggle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            toggle.leadingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor, constant: 16),
            
            // View height constraint
            view.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16)
        ])
        
        return view
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            // Stack view constraints
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupSwitches() {
        popupSwitch.isOn = UserDefaults.standard.bool(forKey: "isPopupEnabled")
        bannerSwitch.isOn = UserDefaults.standard.bool(forKey: "isBannerEnabled")
        
//        popupSwitch.addTarget(self, action: #selector(popupSwitchChanged), for: .valueChanged)
//        bannerSwitch.addTarget(self, action: #selector(bannerSwitchChanged), for: .valueChanged)
    }
    
    private func setupMenu() {
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
//    @objc private func popupSwitchChanged(_ sender: UISwitch) {
//        Netmera.setEnabledPopupPresentation(sender.isOn)
//        UserDefaults.standard.set(sender.isOn, forKey: "isPopupEnabled")
//        popupDescriptionLabel.textColor = sender.isOn ? .secondaryLabel : .systemGray
//    }
//    
//    @objc private func bannerSwitchChanged(_ sender: UISwitch) {
//        Netmera.setEnabledInAppMessagePresentation(sender.isOn)
//        UserDefaults.standard.set(sender.isOn, forKey: "isBannerEnabled")
//        bannerDescriptionLabel.textColor = sender.isOn ? .secondaryLabel : .systemGray
//    }
//    
    @objc private func menuButtonTapped() {
        // Implement side menu functionality here
        print("Menu button tapped")
    }
    
//        Netmera.setEnabledBannerPresentation(sender.isOn)
//        bannerDescriptionLabel.textColor = sender.isOn ? .secondaryLabel : .systemGray
    }
    
   

