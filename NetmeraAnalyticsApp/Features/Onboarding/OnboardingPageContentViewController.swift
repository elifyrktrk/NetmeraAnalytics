//
//  OnboardingPageContentViewController.swift
//  NetmeraAnalyticsApp
//
//  Created by Elif Yürektürk on 12.04.2025.
//

import UIKit

class OnboardingPageContentViewController: UIViewController {

    var page: OnboardingPage?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Add the Start Button programmatically
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isHidden = true // Hidden by default
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PAGE DEBUG:")
            print("Title:", page?.title ?? "yok")
            print("Desc:", page?.description ?? "yok")
            print("Image:", page?.imageName ?? "yok")
        
               
        
     
        titleLabel.text = page?.title
        descriptionLabel.text = page?.description
        imageView.image = UIImage(named: page?.imageName ?? "")
        
        // Add button to view and set constraints
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func startButtonTapped() {
        // Find the parent PageViewController and tell it to navigate
        if let parentVC = parent as? OnboardingPageViewController {
            parentVC.goToLoginScreen()
        }
    }
}
