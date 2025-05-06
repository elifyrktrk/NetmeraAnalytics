//
//  RegisterViewController.swift
//  NetmeraAnalyticsApp
//
//  Created by Elif Yürektürk on 13.04.2025.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    // MARK: - UI Components
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
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("confirm_password", comment: "")
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("register", comment: ""), for: .normal)
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
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("already_have_account_login", comment: "")
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
        view.backgroundColor = .white
        title = NSLocalizedString("register", comment: "")
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        view.addSubview(activityIndicator)
        view.addSubview(loginLabel)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func registerButtonTapped() {
        // Validate input
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            showAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("please_fill_all_fields", comment: ""))
            return
        }
        
        // Validate password match
        guard password == confirmPassword else {
            showAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("passwords_do_not_match", comment: ""))
            return
        }
        
        // Validate password length
        guard password.count >= 6 else {
            showAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("password_minimum_length", comment: ""))
            return
        }
        
        // Show loading state
        setLoading(true)
        
        // Create user with Firebase
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            // Hide loading state
            self.setLoading(false)
            
            if let error = error {
                // Handle specific Firebase auth errors
                let errorMessage: String
                switch error.localizedDescription {
                case "The email address is badly formatted.":
                    errorMessage = NSLocalizedString("enter_valid_email", comment: "")
                case "The email address is already in use by another account.":
                    errorMessage = NSLocalizedString("account_exists", comment: "")
                case "The password must be 6 characters long or more.":
                    errorMessage = NSLocalizedString("password_minimum_length", comment: "")
                default:
                    errorMessage = NSLocalizedString("registration_failed", comment: "")
                }
                self.showAlert(title: NSLocalizedString("registration_failed_title", comment: ""), message: errorMessage)
                return
            }
            
            // Registration successful
            self.showAlert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("registration_success", comment: "")) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
    }
    
    @objc private func loginLabelTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    private func setLoading(_ isLoading: Bool) {
        registerButton.isEnabled = !isLoading
        if isLoading {
            registerButton.setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            registerButton.setTitle(NSLocalizedString("register", comment: ""), for: .normal)
            activityIndicator.stopAnimating()
        }
    }
    
    private func showAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: completion))
        present(alert, animated: true)
    }
}
