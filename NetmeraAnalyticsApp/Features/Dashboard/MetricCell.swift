import UIKit

class MetricCell: UICollectionViewCell {
    static let identifier = "MetricCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trendContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trendLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(trendContainer)
        trendContainer.addSubview(trendImageView)
        trendContainer.addSubview(trendLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            trendContainer.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 8),
            trendContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            trendContainer.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            trendImageView.leadingAnchor.constraint(equalTo: trendContainer.leadingAnchor, constant: 8),
            trendImageView.centerYAnchor.constraint(equalTo: trendContainer.centerYAnchor),
            trendImageView.widthAnchor.constraint(equalToConstant: 12),
            trendImageView.heightAnchor.constraint(equalToConstant: 12),
            
            trendLabel.leadingAnchor.constraint(equalTo: trendImageView.trailingAnchor, constant: 4),
            trendLabel.trailingAnchor.constraint(equalTo: trendContainer.trailingAnchor, constant: -8),
            trendLabel.centerYAnchor.constraint(equalTo: trendContainer.centerYAnchor),
            trendLabel.topAnchor.constraint(equalTo: trendContainer.topAnchor, constant: 4),
            trendLabel.bottomAnchor.constraint(equalTo: trendContainer.bottomAnchor, constant: -4)
        ])
    }
    
    // MARK: - Configuration
    func configure(with item: MetricItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
        
        switch item.trend {
        case .up(let percentage):
            trendImageView.image = UIImage(systemName: "arrow.up.right")
            trendImageView.tintColor = .systemGreen
            trendLabel.textColor = .systemGreen
            trendLabel.text = String(format: "+%.1f%%", percentage)
        case .down(let percentage):
            trendImageView.image = UIImage(systemName: "arrow.down.right")
            trendImageView.tintColor = .systemRed
            trendLabel.textColor = .systemRed
            trendLabel.text = String(format: "-%.1f%%", percentage)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
        trendLabel.text = nil
    }
} 