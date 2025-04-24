import UIKit

class HelpViewController: UIViewController {
    
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
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search help articles"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let popularTopicsCard: UIView = {
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
    
    private let popularTopicsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Topics"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popularTopicsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let contactSupportCard: UIView = {
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
    
    private let contactSupportTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Support"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contactSupportStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Help"
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Add search bar
        view.addSubview(searchBar)
        
        // Setup scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Add stack view to scroll view
        scrollView.addSubview(stackView)
        
        // Add cards to stack view
        stackView.addArrangedSubview(popularTopicsCard)
        stackView.addArrangedSubview(contactSupportCard)
        
        // Setup popular topics card
        popularTopicsCard.addSubview(popularTopicsTitleLabel)
        popularTopicsCard.addSubview(popularTopicsStack)
        
        // Setup contact support card
        contactSupportCard.addSubview(contactSupportTitleLabel)
        contactSupportCard.addSubview(contactSupportStack)
        
        // Add popular topics
        addTopicsToStack(popularTopicsStack, topics: [
            ("Getting Started", "Learn the basics of Netmera"),
            ("Push Notifications", "Configure and send push notifications"),
            ("Analytics", "Track user behavior and events"),
            ("User Segmentation", "Create and manage user segments")
        ])
        
        // Add contact support options
        addContactOptionsToStack(contactSupportStack, options: [
            ("Email Support", "support@netmera.com"),
            ("Live Chat", "Available 24/7"),
            ("Documentation", "Browse our documentation")
        ])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            // Popular Topics Card constraints
            popularTopicsTitleLabel.topAnchor.constraint(equalTo: popularTopicsCard.topAnchor, constant: 16),
            popularTopicsTitleLabel.leadingAnchor.constraint(equalTo: popularTopicsCard.leadingAnchor, constant: 16),
            popularTopicsTitleLabel.trailingAnchor.constraint(equalTo: popularTopicsCard.trailingAnchor, constant: -16),
            
            popularTopicsStack.topAnchor.constraint(equalTo: popularTopicsTitleLabel.bottomAnchor, constant: 16),
            popularTopicsStack.leadingAnchor.constraint(equalTo: popularTopicsCard.leadingAnchor, constant: 16),
            popularTopicsStack.trailingAnchor.constraint(equalTo: popularTopicsCard.trailingAnchor, constant: -16),
            popularTopicsStack.bottomAnchor.constraint(equalTo: popularTopicsCard.bottomAnchor, constant: -16),
            
            // Contact Support Card constraints
            contactSupportTitleLabel.topAnchor.constraint(equalTo: contactSupportCard.topAnchor, constant: 16),
            contactSupportTitleLabel.leadingAnchor.constraint(equalTo: contactSupportCard.leadingAnchor, constant: 16),
            contactSupportTitleLabel.trailingAnchor.constraint(equalTo: contactSupportCard.trailingAnchor, constant: -16),
            
            contactSupportStack.topAnchor.constraint(equalTo: contactSupportTitleLabel.bottomAnchor, constant: 16),
            contactSupportStack.leadingAnchor.constraint(equalTo: contactSupportCard.leadingAnchor, constant: 16),
            contactSupportStack.trailingAnchor.constraint(equalTo: contactSupportCard.trailingAnchor, constant: -16),
            contactSupportStack.bottomAnchor.constraint(equalTo: contactSupportCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func addTopicsToStack(_ stack: UIStackView, topics: [(title: String, description: String)]) {
        for topic in topics {
            let topicView = createTopicView(title: topic.title, description: topic.description)
            stack.addArrangedSubview(topicView)
        }
    }
    
    private func createTopicView(title: String, description: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .secondaryLabel
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            chevronImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return view
    }
    
    private func addContactOptionsToStack(_ stack: UIStackView, options: [(title: String, description: String)]) {
        for option in options {
            let optionView = createContactOptionView(title: option.title, description: option.description)
            stack.addArrangedSubview(optionView)
        }
    }
    
    private func createContactOptionView(title: String, description: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .secondaryLabel
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            chevronImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return view
    }
} 