import UIKit

class ChartCell: UICollectionViewCell {
    static let identifier = "ChartCell"
    
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
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Sample data points for the chart
    private var dataPoints: [CGFloat] = []
    private let dataLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
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
        containerView.addSubview(chartView)
        
        chartView.layer.addSublayer(gradientLayer)
        chartView.layer.addSublayer(dataLayer)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            chartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chartView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = chartView.bounds
        updateChartIfNeeded()
    }
    
    // MARK: - Configuration
    func configure(with title: String, data: [CGFloat]) {
        titleLabel.text = title
        dataPoints = data
        updateChartIfNeeded()
    }
    
    private func updateChartIfNeeded() {
        guard !dataPoints.isEmpty, chartView.bounds.width > 0 else { return }
        
        // Create the line path
        let path = UIBezierPath()
        let maxValue = dataPoints.max() ?? 1
        let minValue = dataPoints.min() ?? 0
        let range = maxValue - minValue
        
        let width = chartView.bounds.width
        let height = chartView.bounds.height
        let stepX = width / CGFloat(dataPoints.count - 1)
        
        dataPoints.enumerated().forEach { index, point in
            let x = CGFloat(index) * stepX
            let y = height - (point - minValue) / range * height
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        // Add gradient
        let gradientPath = path.copy() as! UIBezierPath
        gradientPath.addLine(to: CGPoint(x: width, y: height))
        gradientPath.addLine(to: CGPoint(x: 0, y: height))
        gradientPath.close()
        
        // Configure gradient layer
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.3).cgColor,
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        // Configure line layer
        dataLayer.path = path.cgPath
        dataLayer.strokeColor = UIColor.systemBlue.cgColor
        dataLayer.fillColor = nil
        dataLayer.lineWidth = 2
        dataLayer.lineCap = .round
        dataLayer.lineJoin = .round
        
        // Animate
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.0
        dataLayer.add(animation, forKey: "lineAnimation")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dataPoints.removeAll()
        dataLayer.path = nil
    }
} 