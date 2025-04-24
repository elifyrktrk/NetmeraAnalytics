import UIKit

class FeedbackViewController: UIViewController {
    
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
    
    private let feedbackCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let feedbackTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Send Feedback"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feedbackDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "We'd love to hear your thoughts about Netmera"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .label
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let feedbackTypeSegmentedControl: UISegmentedControl = {
        let items = ["Bug Report", "Feature Request", "General Feedback"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit Feedback", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Feedback"
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Setup scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Add stack view to scroll view
        scrollView.addSubview(stackView)
        
        // Add feedback card to stack view
        stackView.addArrangedSubview(feedbackCard)
        
        // Setup feedback card
        feedbackCard.addSubview(feedbackTitleLabel)
        feedbackCard.addSubview(feedbackDescriptionLabel)
        feedbackCard.addSubview(feedbackTypeSegmentedControl)
        feedbackCard.addSubview(feedbackTextView)
        feedbackCard.addSubview(submitButton)
        
        // Add button action
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            // Feedback Card constraints
            feedbackTitleLabel.topAnchor.constraint(equalTo: feedbackCard.topAnchor, constant: 16),
            feedbackTitleLabel.leadingAnchor.constraint(equalTo: feedbackCard.leadingAnchor, constant: 16),
            feedbackTitleLabel.trailingAnchor.constraint(equalTo: feedbackCard.trailingAnchor, constant: -16),
            
            feedbackDescriptionLabel.topAnchor.constraint(equalTo: feedbackTitleLabel.bottomAnchor, constant: 4),
            feedbackDescriptionLabel.leadingAnchor.constraint(equalTo: feedbackCard.leadingAnchor, constant: 16),
            feedbackDescriptionLabel.trailingAnchor.constraint(equalTo: feedbackCard.trailingAnchor, constant: -16),
            
            feedbackTypeSegmentedControl.topAnchor.constraint(equalTo: feedbackDescriptionLabel.bottomAnchor, constant: 16),
            feedbackTypeSegmentedControl.leadingAnchor.constraint(equalTo: feedbackCard.leadingAnchor, constant: 16),
            feedbackTypeSegmentedControl.trailingAnchor.constraint(equalTo: feedbackCard.trailingAnchor, constant: -16),
            
            feedbackTextView.topAnchor.constraint(equalTo: feedbackTypeSegmentedControl.bottomAnchor, constant: 16),
            feedbackTextView.leadingAnchor.constraint(equalTo: feedbackCard.leadingAnchor, constant: 16),
            feedbackTextView.trailingAnchor.constraint(equalTo: feedbackCard.trailingAnchor, constant: -16),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 200),
            
            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 16),
            submitButton.leadingAnchor.constraint(equalTo: feedbackCard.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: feedbackCard.trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.bottomAnchor.constraint(equalTo: feedbackCard.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    @objc private func submitButtonTapped() {
        // Show success alert
        let alert = UIAlertController(title: "Thank You!", message: "Your feedback has been submitted successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
} 