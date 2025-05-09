//
//  LoginViewController.swift
//  NetmeraAnalyticsApp
//
//  Created by Elif Yürektürk on 13.04.2025.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    // MARK: - UI Components (Programmatic)
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("email", comment: "")
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("password", comment: "")
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("dont_have_account_signup", comment: "")
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        title = NSLocalizedString("login", comment: "")
        view.backgroundColor = .white
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            
            registerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(registerLabelTapped))
        registerLabel.addGestureRecognizer(tapGesture)
    }

    // MARK: - Actions
    @objc private func loginButtonTapped() {
        // Validate input
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty, !password.isEmpty else {
            showAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("please_fill_all_fields", comment: ""))
            return
        }
        
        // Show loading state
        setLoading(true)
        
        // Attempt to sign in with Firebase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            // Hide loading state
            self.setLoading(false)
            
            if let error = error {
                // Handle specific Firebase auth errors
                let errorMessage: String
                switch error.localizedDescription {
                case "The password is invalid or the user does not have a password.":
                    errorMessage = NSLocalizedString("invalid_password", comment: "")
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    errorMessage = NSLocalizedString("no_account_found", comment: "")
                case "The email address is badly formatted.":
                    errorMessage = NSLocalizedString("enter_valid_email", comment: "")
                default:
                    errorMessage = NSLocalizedString("generic_error", comment: "")
                }
                self.showAlert(title: NSLocalizedString("login_failed", comment: ""), message: errorMessage)
                return
            }
            
            // Login successful
            print("User logged in successfully")
            self.handleLoginSuccess()
        }
    }
    
    @objc private func registerLabelTapped() {
        let registerVC = RegisterViewController()
        present(registerVC, animated: true)
    }
    
    // MARK: - Helper Methods
    private func setLoading(_ isLoading: Bool) {
        loginButton.isEnabled = !isLoading
        if isLoading {
            loginButton.setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            loginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
            activityIndicator.stopAnimating()
        }
    }
    
    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: completion))
        present(alert, animated: true)
    }
    
    // After successful login
    private func handleLoginSuccess() {
        // Create view controllers
        let dashboardVC = DashboardViewController()
        let navigationController = UINavigationController(rootViewController: dashboardVC)
        let containerVC = ContainerViewController(mainViewController: navigationController)
        
        // Set the container as root view controller
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = containerVC
        } else {
            // Fallback to present modally if we can't set root
            containerVC.modalPresentationStyle = .fullScreen
            present(containerVC, animated: true)
        }
    }
}

