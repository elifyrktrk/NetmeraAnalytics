import UIKit
import NetmeraCore

class TestNetmeraViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private let testPushButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Test Push Notification", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(testPushTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let testInAppButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Test In-App Message", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(testInAppTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let testEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Test Event", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(testEventTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        title = "Test Netmera"
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        // Always show the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Configure the navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Only add the menu button if we're the root view controller
        if navigationController?.viewControllers.first === self {
            let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(menuButtonTapped))
            navigationItem.leftBarButtonItem = menuButton
        }
    }
    
    @objc private func menuButtonTapped() {
        // Find the container view controller and toggle the menu
        if let containerVC = navigationController?.parent as? ContainerViewController {
            containerVC.toggleMenu()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Configure the view to respect the safe area
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = true
        
        // Add scroll view to view
        view.addSubview(scrollView)
        
        // Add content view to scroll view
        scrollView.addSubview(contentView)
        
        // Add stack view to content view
        contentView.addSubview(stackView)
        
        // Add buttons to stack view
        stackView.addArrangedSubview(testPushButton)
        stackView.addArrangedSubview(testInAppButton)
        stackView.addArrangedSubview(testEventButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Stack view constraints
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
            
            // Button constraints
            testPushButton.heightAnchor.constraint(equalToConstant: 50),
            testInAppButton.heightAnchor.constraint(equalToConstant: 50),
            testEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func testPushTapped() {
        let composerVC = PushNotificationComposerViewController()
        let navController = UINavigationController(rootViewController: composerVC)
        present(navController, animated: true)
    }
    
    @objc private func testInAppTapped() {
        // Test in-app message
        let alert = UIAlertController(title: "Test In-App",
                                    message: "In-app message test initiated",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func testEventTapped() {
        // Test event
        let alert = UIAlertController(title: "Test Event",
                                    message: "Event test initiated",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 