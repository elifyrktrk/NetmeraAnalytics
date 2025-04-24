import UIKit
import NetmeraCore

class TestNetmeraViewController: UIViewController {
    
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
        title = "Test Netmera"
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add close button to navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(closeTapped))
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(testPushButton)
        stackView.addArrangedSubview(testInAppButton)
        stackView.addArrangedSubview(testEventButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            testPushButton.heightAnchor.constraint(equalToConstant: 50),
            testInAppButton.heightAnchor.constraint(equalToConstant: 50),
            testEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func testPushTapped() {
        // Test push notification
        let alert = UIAlertController(title: "Test Push",
                                    message: "Push notification test initiated",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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