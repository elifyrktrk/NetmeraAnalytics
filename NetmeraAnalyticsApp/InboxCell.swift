import UIKit
import NetmeraCore
import NetmeraNotificationCore
import NetmeraNotificationInbox

// NetmeraInboxCell.swift
class InboxCell: UITableViewCell {
    static let identifier = "NetmeraInboxCell"

    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [titleLabel, bodyLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        titleLabel.font = .boldSystemFont(ofSize: 16)
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.numberOfLines = 2
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with data: NetmeraInboxPush) {
        titleLabel.text = data.alert?.title ?? "No Title"
        bodyLabel.text = data.alert?.body ?? "No Content"
        if let sendDate = data.push?.sendDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            dateLabel.text = formatter.string(from: sendDate)
        } else {
            dateLabel.text = nil
        }
    }
}

//import UIKit
//
//class InboxCell: UITableViewCell {
//    static let identifier = "InboxCell"
//    
//    // MARK: - UI Components
//    private let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .secondarySystemBackground
//        view.layer.cornerRadius = 12
//        view.clipsToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 17, weight: .semibold)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let bodyLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 15)
//        label.textColor = .secondaryLabel
//        label.numberOfLines = 2
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let timestampLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13)
//        label.textColor = .tertiaryLabel
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let unreadIndicator: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBlue
//        view.layer.cornerRadius = 4
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let chevronImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "chevron.right")
//        imageView.tintColor = .tertiaryLabel
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    // MARK: - Initialization
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Setup
//    private func setupUI() {
//        backgroundColor = .clear
//        selectionStyle = .none
//        
//        contentView.addSubview(containerView)
//        containerView.addSubview(unreadIndicator)
//        containerView.addSubview(titleLabel)
//        containerView.addSubview(bodyLabel)
//        containerView.addSubview(timestampLabel)
//        containerView.addSubview(chevronImageView)
//        
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//            
//            unreadIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            unreadIndicator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
//            unreadIndicator.widthAnchor.constraint(equalToConstant: 8),
//            unreadIndicator.heightAnchor.constraint(equalToConstant: 8),
//            
//            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
//            titleLabel.leadingAnchor.constraint(equalTo: unreadIndicator.trailingAnchor, constant: 12),
//            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
//            
//            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
//            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//            
//            timestampLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
//            timestampLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            timestampLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
//            
//            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
//            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
//            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
//        ])
//    }
//    
//    // MARK: - Configuration
//    func configure(with notification: InboxNotification) {
//        titleLabel.text = notification.title
//        bodyLabel.text = notification.body
//        timestampLabel.text = notification.formattedDate
//        unreadIndicator.isHidden = notification.isRead
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        titleLabel.text = nil
//        bodyLabel.text = nil
//        timestampLabel.text = nil
//        unreadIndicator.isHidden = true
//    }
//} 
