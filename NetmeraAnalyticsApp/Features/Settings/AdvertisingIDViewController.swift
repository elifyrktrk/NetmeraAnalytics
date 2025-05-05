import UIKit
import NetmeraCore
import NetmeraAdvertisingId
import AppTrackingTransparency
import AdSupport

private let advertisingIDEnabledKey = "advertisingIDEnabled"

class AdvertisingIDViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let requestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Request Advertising ID Permission", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let toggleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Advertising ID"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toggleSwitch = UISwitch()
    
    private let idContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let idTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Advertising ID"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Advertising ID"
        
        // Configure back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add subviews
        contentView.addSubview(requestButton)
        contentView.addSubview(toggleView)
        toggleView.addSubview(toggleLabel)
        toggleView.addSubview(toggleSwitch)
        contentView.addSubview(idContainerView)
        idContainerView.addSubview(idTitleLabel)
        idContainerView.addSubview(idValueLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            requestButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            requestButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            requestButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            requestButton.heightAnchor.constraint(equalToConstant: 50),
            
            toggleView.topAnchor.constraint(equalTo: requestButton.bottomAnchor, constant: 24),
            toggleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            toggleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            toggleLabel.topAnchor.constraint(equalTo: toggleView.topAnchor, constant: 16),
            toggleLabel.leadingAnchor.constraint(equalTo: toggleView.leadingAnchor, constant: 16),
            toggleLabel.bottomAnchor.constraint(equalTo: toggleView.bottomAnchor, constant: -16),
            
            toggleSwitch.centerYAnchor.constraint(equalTo: toggleLabel.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: toggleView.trailingAnchor, constant: -16),
            
            idContainerView.topAnchor.constraint(equalTo: toggleView.bottomAnchor, constant: 16),
            idContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            idContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            idContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            idTitleLabel.topAnchor.constraint(equalTo: idContainerView.topAnchor, constant: 16),
            idTitleLabel.leadingAnchor.constraint(equalTo: idContainerView.leadingAnchor, constant: 16),
            
            idValueLabel.topAnchor.constraint(equalTo: idTitleLabel.bottomAnchor, constant: 8),
            idValueLabel.leadingAnchor.constraint(equalTo: idContainerView.leadingAnchor, constant: 16),
            idValueLabel.trailingAnchor.constraint(equalTo: idContainerView.trailingAnchor, constant: -16),
            idValueLabel.bottomAnchor.constraint(equalTo: idContainerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupActions() {
        requestButton.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
        toggleSwitch.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func requestButtonTapped() {
        // Netmera üzerinden izin iste
        Netmera.requestAdvertisingAuthorization()
        
        // İzin durumunu kontrol et ve switch'i güncelle
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            let isAuthorized = status == .authorized
            
            if isAuthorized {
                toggleSwitch.setOn(true, animated: true)
                UserDefaults.standard.set(true, forKey: advertisingIDEnabledKey)
                Netmera.setAuthorizedAdvertisingIdentifier(authorized: true)
            }
        } else {
            let isAuthorized = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            if isAuthorized {
                toggleSwitch.setOn(true, animated: true)
                UserDefaults.standard.set(true, forKey: advertisingIDEnabledKey)
                Netmera.setAuthorizedAdvertisingIdentifier(authorized: true)
            }
        }
        
        updateUI()
    }
    
    @objc private func toggleValueChanged(_ sender: UISwitch) {
        // UserDefaults'u güncelle
        UserDefaults.standard.set(sender.isOn, forKey: advertisingIDEnabledKey)
        
        if sender.isOn {
            // Eğer etkinleştiriliyorsa, kullanıcıdan izin iste
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                    DispatchQueue.main.async {
                        let isAuthorized = status == .authorized
                        // Netmera'ya durumu bildir
                        Netmera.setAuthorizedAdvertisingIdentifier(authorized: isAuthorized)
                        // Eğer izin verilmediyse switch'i kapat
                        if !isAuthorized {
                            sender.setOn(false, animated: true)
                            UserDefaults.standard.set(false, forKey: advertisingIDEnabledKey)
                        }
                        self?.updateUI()
                    }
                }
            } else {
                // iOS 14 altı için doğrudan istek yap
                Netmera.requestAdvertisingAuthorization()
                let isAuthorized = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
                Netmera.setAuthorizedAdvertisingIdentifier(authorized: isAuthorized)
                // Eğer izin verilmediyse switch'i kapat
                if !isAuthorized {
                    sender.setOn(false, animated: true)
                    UserDefaults.standard.set(false, forKey: advertisingIDEnabledKey)
                }
                updateUI()
            }
        } else {
            // Devre dışı bırakılıyorsa Netmera'yı güncelle
            Netmera.setAuthorizedAdvertisingIdentifier(authorized: false)
            updateUI()
        }
    }
    
    private var isAdvertisingTrackingEnabled: Bool {
        return UserDefaults.standard.bool(forKey: advertisingIDEnabledKey)
    }
    

    
    private func updateUI() {
        // UserDefaults'tan mevcut durumu al
        let isAuthorized = isAdvertisingTrackingEnabled
        print("Updating UI. isAuthorized: \(isAuthorized)")
        
        // Switch durumunu güncelle (aksiyon tetiklenmeden)
        toggleSwitch.removeTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        toggleSwitch.isOn = isAuthorized
        toggleSwitch.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        
        // ID'yi göster (eğer izin verilmişse)
        if isAuthorized {
            // Netmera otomatik olarak reklam tanımlayıcısını alacak
            idValueLabel.text = "Advertising ID is enabled"
            print("Advertising ID is enabled")
        } else {
            idValueLabel.text = "Not available (Not authorized)"
        }
        
        // Switch'in etkinliğini güncelle
        toggleSwitch.isEnabled = true
    }
}
