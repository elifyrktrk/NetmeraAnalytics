import UIKit
import FirebaseAuth
import NetmeraCore


class ProfileViewController: UIViewController {
    
    // MARK: - UI Components
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
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "User ID (required)"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "profile_user_id_textfield"
        return textField
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "profile_name_textfield"
        return textField
    }()
    
    private let surnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Surname"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "profile_surname_textfield"
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "profile_email_textfield"
        return textField
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update Profile", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "profile_update_button"
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userIdTextField, nameTextField, surnameTextField, emailTextField, updateButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupKeyboardDismissal()
        updateUserInfo()
        
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        // Add close button to navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(closeTapped))
        
        // Add ScrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add elements to ContentView
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(logoutButton)
        
        // ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor) // Important for vertical scrolling
        ])
        
        // ContentView Element Constraints
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30), // Adjusted spacing
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            userIdTextField.heightAnchor.constraint(equalToConstant: 50),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            surnameTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30), // Spacing before logout
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32) // Important: Define bottom constraint for content view height
        ])
    }
    
    private func setupActions() {
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allow touches to pass through to buttons, etc.
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateUserInfo() {
        if let user = Auth.auth().currentUser {
            // Update display labels
            nameLabel.text = user.displayName ?? "User"
            emailLabel.text = user.email
            emailTextField.text = user.email // Pre-fill email field
            
            // Try to parse display name for name/surname (simple split)
            if let displayName = user.displayName, let firstSpace = displayName.firstIndex(of: " ") {
                nameTextField.text = String(displayName[..<firstSpace])
                surnameTextField.text = String(displayName[displayName.index(after: firstSpace)...])
            } else {
                nameTextField.text = user.displayName // Fallback
            }
        }
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Logout",
                                    message: "Are you sure you want to logout?",
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                // Navigate back to login
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.showLoginScreen()
                } else {
                    // Fallback if SceneDelegate access fails
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self?.present(loginVC, animated: true, completion: {
                        // Ensure the profile VC is dismissed if presented modally over another structure
                         self?.navigationController?.dismiss(animated: false)
                         self?.dismiss(animated: false)
                    })
                }
            } catch {
                let errorAlert = UIAlertController(title: "Error",
                                                 message: "Failed to logout. Please try again.",
                                                 preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(errorAlert, animated: true)
            }
        })
        
        present(alert, animated: true)
    }
    
    @objc private func updateButtonTapped() {
        dismissKeyboard() // Dismiss keyboard before proceeding
        
        guard let userId = userIdTextField.text, !userId.isEmpty else {
            showAlert(title: "Missing Information", message: "User ID is required.")
            return
        }
        
        let name = nameTextField.text
        let surname = surnameTextField.text
        let email = emailTextField.text
        
        // Create NetmeraUser object
        var user = NetmeraUser()
        user.userId = userId
        user.name = name
        user.surname = surname
        user.email = email
        
        // Update user information via Netmera
        Netmera.updateUser(user: user)
        
        // Update Firebase Profile (Optional - good practice)
        if let currentUser = Auth.auth().currentUser {
            let changeRequest = currentUser.createProfileChangeRequest()
            var displayNameParts: [String?] = [name, surname]
            changeRequest.displayName = displayNameParts.compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " ")
            if let email = email, !email.isEmpty, email != currentUser.email {
                 changeRequest.commitChanges { error in
                     if let error = error {
                         print("Firebase profile update error: \(error)")
                     } else {
                         // Optionally update email separately if needed (requires verification)
                         print("Firebase display name updated.")
                     }
                 }
             } else {
                  changeRequest.commitChanges { error in
                       if let error = error {
                           print("Firebase profile update error: \(error)")
                       } else {
                           print("Firebase display name updated.")
                       }
                   }
             }
        }
        
        // Show success message
        showAlert(title: "Profile Updated", message: "User information sent to Netmera.")
        
        // Refresh displayed info
        updateUserInfo()
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 
