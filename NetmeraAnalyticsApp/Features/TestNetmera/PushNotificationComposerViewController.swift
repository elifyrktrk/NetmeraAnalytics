
import UIKit

class PushNotificationComposerViewController: UIViewController, UITextFieldDelegate {
    // Sound picker
    private var soundFiles: [String] = []
    private var selectedSound: String?
    
    // Modern sound selection view
    private let soundSelectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let soundIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.wave.2.fill")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let soundNameLabel: UILabel = {
        let label = UILabel()
        label.text = "None"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let soundArrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    
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
        loadSoundFiles()
    }
    
    private func loadSoundFiles() {
        // Önce Library/Sound altını dene
        if let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: "Library/Sound") {
            print("[DEBUG] Library/Sound içindeki mp3 dosyaları:", urls.map { $0.lastPathComponent })
            if !urls.isEmpty {
                self.soundFiles = urls.map { $0.lastPathComponent }
                return
            }
        }
        // Sonra bundle root'u dene
        if let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) {
            print("[DEBUG] Bundle root'taki mp3 dosyaları:", urls.map { $0.lastPathComponent })
            if !urls.isEmpty {
                self.soundFiles = urls.map { $0.lastPathComponent }
                return
            }
        }
        print("[DEBUG] mp3 dosyası bulunamadı.")
        self.soundFiles = []
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
            createLabel("Sound"),
            soundSelectionView,
            sendButton
        ])
        // SoundSelectionView içeriği ve gesture
        soundSelectionView.addSubview(soundIconView)
        soundSelectionView.addSubview(soundNameLabel)
        soundSelectionView.addSubview(soundArrowView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(soundButtonTapped))
        soundSelectionView.addGestureRecognizer(tap)
        NSLayoutConstraint.activate([
            soundIconView.leadingAnchor.constraint(equalTo: soundSelectionView.leadingAnchor, constant: 12),
            soundIconView.centerYAnchor.constraint(equalTo: soundSelectionView.centerYAnchor),
            soundIconView.widthAnchor.constraint(equalToConstant: 24),
            soundIconView.heightAnchor.constraint(equalToConstant: 24),
            soundArrowView.trailingAnchor.constraint(equalTo: soundSelectionView.trailingAnchor, constant: -12),
            soundArrowView.centerYAnchor.constraint(equalTo: soundSelectionView.centerYAnchor),
            soundArrowView.widthAnchor.constraint(equalToConstant: 16),
            soundArrowView.heightAnchor.constraint(equalToConstant: 16),
            soundNameLabel.leadingAnchor.constraint(equalTo: soundIconView.trailingAnchor, constant: 12),
            soundNameLabel.trailingAnchor.constraint(equalTo: soundArrowView.leadingAnchor, constant: -12),
            soundNameLabel.centerYAnchor.constraint(equalTo: soundSelectionView.centerYAnchor),
            soundSelectionView.heightAnchor.constraint(equalToConstant: 44)
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
        
        sendPushNotification(title: title, message: message, sound: selectedSound)
    }
    
    private func sendPushNotification(title: String, message: String, sound: String?) {
        activityIndicator.startAnimating()
        sendButton.isEnabled = false
        
        let url = URL(string: "https://restapi.netmera.com/rest/3.0/sendBulkNotification")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("N79vhZlSKZCPYboSdLcJClI6d08G4mF2vMqUPR9Uvy8nBPDb_rB_8rQVPEjbkEw7", forHTTPHeaderField: "X-netmera-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var messageDict: [String: Any] = [
            "title": title,
            "platforms": ["IOS"],
            "text": message
        ]
        if let sound = sound, !sound.isEmpty {
            messageDict["ios"] = ["sound": sound]
        }
        let requestBody: [String: Any] = [
            "message": messageDict,
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
    
    // MARK: - Sound Picker
    @objc private func soundButtonTapped() {
        let alert = UIAlertController(title: "Select Sound", message: nil, preferredStyle: .actionSheet)
        for sound in soundFiles {
            alert.addAction(UIAlertAction(title: sound, style: .default, handler: { [weak self] _ in
                self?.selectedSound = sound
                self?.soundNameLabel.text = sound
            }))
        }
        alert.addAction(UIAlertAction(title: "None", style: .destructive, handler: { [weak self] _ in
            self?.selectedSound = nil
            self?.soundNameLabel.text = "None"
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
