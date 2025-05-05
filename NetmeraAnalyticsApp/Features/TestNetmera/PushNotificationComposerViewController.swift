import UIKit

class PushNotificationComposerViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - UI Components
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Push Notification Title"
        textField.returnKeyType = .done
        return textField
    }()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "This is the push notification text!"
        return textView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Push Notification", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        titleTextField.delegate = self
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Compose Push"
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let stackView = UIStackView(arrangedSubviews: [
            createLabel("Campaign Name"),
            titleTextField,
            createLabel("Message"),
            messageTextView,
            sendButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            messageTextView.heightAnchor.constraint(equalToConstant: 150),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Dismiss keyboard when return is pressed on title text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func sendButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let message = messageTextView.text, !message.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        sendPushNotification(title: title, message: message)
    }
    
    private func sendPushNotification(title: String, message: String) {
        activityIndicator.startAnimating()
        sendButton.isEnabled = false
        
        let url = URL(string: "https://restapi.netmera.com/rest/3.0/sendBulkNotification")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("N79vhZlSKZCPYboSdLcJClI6d08G4mF2vMqUPR9Uvy8nBPDb_rB_8rQVPEjbkEw7", forHTTPHeaderField: "X-netmera-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "message": [
                "title": title,
                "platforms": ["IOS"],
                "text": message
            ],
            "target": [
                "sendToAll": true
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.sendButton.isEnabled = true
                    
                    if let error = error {
                        self?.showAlert(title: "Error", message: "Failed to send push: \(error.localizedDescription)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        self?.showAlert(title: "Success", message: "Push notification sent successfully!") {
                            self?.dismiss(animated: true)
                        }
                    } else {
                        self?.showAlert(title: "Error", message: "Failed to send push notification")
                    }
                }
            }
            task.resume()
            
        } catch {
            activityIndicator.stopAnimating()
            sendButton.isEnabled = true
            showAlert(title: "Error", message: "Failed to create request: \(error.localizedDescription)")
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
