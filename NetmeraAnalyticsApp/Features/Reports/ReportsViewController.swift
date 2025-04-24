import UIKit

class ReportsViewController: UIViewController {
    
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
    
    private let dailyReportCard: UIView = {
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
    
    private let dailyReportTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Report"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dailyReportDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Today, \(Date().formatted(date: .abbreviated, time: .omitted))"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dailyReportMetricsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let weeklyReportCard: UIView = {
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
    
    private let weeklyReportTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly Report"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weeklyReportDateLabel: UILabel = {
        let label = UILabel()
        label.text = "This Week"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weeklyReportMetricsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let monthlyReportCard: UIView = {
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
    
    private let monthlyReportTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Monthly Report"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let monthlyReportDateLabel: UILabel = {
        let label = UILabel()
        label.text = "This Month"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let monthlyReportMetricsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Reports"
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // Add refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Setup scroll view
        let scrollView = UIScrollView()
        scrollView.refreshControl = refreshControl
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Add stack view to scroll view
        scrollView.addSubview(stackView)
        
        // Add cards to stack view
        stackView.addArrangedSubview(dailyReportCard)
        stackView.addArrangedSubview(weeklyReportCard)
        stackView.addArrangedSubview(monthlyReportCard)
        
        // Setup daily report card
        dailyReportCard.addSubview(dailyReportTitleLabel)
        dailyReportCard.addSubview(dailyReportDateLabel)
        dailyReportCard.addSubview(dailyReportMetricsStack)
        
        // Setup weekly report card
        weeklyReportCard.addSubview(weeklyReportTitleLabel)
        weeklyReportCard.addSubview(weeklyReportDateLabel)
        weeklyReportCard.addSubview(weeklyReportMetricsStack)
        
        // Setup monthly report card
        monthlyReportCard.addSubview(monthlyReportTitleLabel)
        monthlyReportCard.addSubview(monthlyReportDateLabel)
        monthlyReportCard.addSubview(monthlyReportMetricsStack)
        
        // Add metrics to stacks
        addMetricsToStack(dailyReportMetricsStack, metrics: [
            ("Active Users", "1,234", "+5.2%"),
            ("Events", "4,567", "+8.1%"),
            ("Sessions", "2,345", "+3.4%")
        ])
        
        addMetricsToStack(weeklyReportMetricsStack, metrics: [
            ("Active Users", "8,765", "+12.3%"),
            ("Events", "32,456", "+15.6%"),
            ("Sessions", "16,234", "+9.8%")
        ])
        
        addMetricsToStack(monthlyReportMetricsStack, metrics: [
            ("Active Users", "45,678", "+18.7%"),
            ("Events", "156,789", "+22.4%"),
            ("Sessions", "78,345", "+15.2%")
        ])
        
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
            
            // Daily Report Card constraints
            dailyReportTitleLabel.topAnchor.constraint(equalTo: dailyReportCard.topAnchor, constant: 16),
            dailyReportTitleLabel.leadingAnchor.constraint(equalTo: dailyReportCard.leadingAnchor, constant: 16),
            dailyReportTitleLabel.trailingAnchor.constraint(equalTo: dailyReportCard.trailingAnchor, constant: -16),
            
            dailyReportDateLabel.topAnchor.constraint(equalTo: dailyReportTitleLabel.bottomAnchor, constant: 4),
            dailyReportDateLabel.leadingAnchor.constraint(equalTo: dailyReportCard.leadingAnchor, constant: 16),
            dailyReportDateLabel.trailingAnchor.constraint(equalTo: dailyReportCard.trailingAnchor, constant: -16),
            
            dailyReportMetricsStack.topAnchor.constraint(equalTo: dailyReportDateLabel.bottomAnchor, constant: 16),
            dailyReportMetricsStack.leadingAnchor.constraint(equalTo: dailyReportCard.leadingAnchor, constant: 16),
            dailyReportMetricsStack.trailingAnchor.constraint(equalTo: dailyReportCard.trailingAnchor, constant: -16),
            dailyReportMetricsStack.bottomAnchor.constraint(equalTo: dailyReportCard.bottomAnchor, constant: -16),
            
            // Weekly Report Card constraints
            weeklyReportTitleLabel.topAnchor.constraint(equalTo: weeklyReportCard.topAnchor, constant: 16),
            weeklyReportTitleLabel.leadingAnchor.constraint(equalTo: weeklyReportCard.leadingAnchor, constant: 16),
            weeklyReportTitleLabel.trailingAnchor.constraint(equalTo: weeklyReportCard.trailingAnchor, constant: -16),
            
            weeklyReportDateLabel.topAnchor.constraint(equalTo: weeklyReportTitleLabel.bottomAnchor, constant: 4),
            weeklyReportDateLabel.leadingAnchor.constraint(equalTo: weeklyReportCard.leadingAnchor, constant: 16),
            weeklyReportDateLabel.trailingAnchor.constraint(equalTo: weeklyReportCard.trailingAnchor, constant: -16),
            
            weeklyReportMetricsStack.topAnchor.constraint(equalTo: weeklyReportDateLabel.bottomAnchor, constant: 16),
            weeklyReportMetricsStack.leadingAnchor.constraint(equalTo: weeklyReportCard.leadingAnchor, constant: 16),
            weeklyReportMetricsStack.trailingAnchor.constraint(equalTo: weeklyReportCard.trailingAnchor, constant: -16),
            weeklyReportMetricsStack.bottomAnchor.constraint(equalTo: weeklyReportCard.bottomAnchor, constant: -16),
            
            // Monthly Report Card constraints
            monthlyReportTitleLabel.topAnchor.constraint(equalTo: monthlyReportCard.topAnchor, constant: 16),
            monthlyReportTitleLabel.leadingAnchor.constraint(equalTo: monthlyReportCard.leadingAnchor, constant: 16),
            monthlyReportTitleLabel.trailingAnchor.constraint(equalTo: monthlyReportCard.trailingAnchor, constant: -16),
            
            monthlyReportDateLabel.topAnchor.constraint(equalTo: monthlyReportTitleLabel.bottomAnchor, constant: 4),
            monthlyReportDateLabel.leadingAnchor.constraint(equalTo: monthlyReportCard.leadingAnchor, constant: 16),
            monthlyReportDateLabel.trailingAnchor.constraint(equalTo: monthlyReportCard.trailingAnchor, constant: -16),
            
            monthlyReportMetricsStack.topAnchor.constraint(equalTo: monthlyReportDateLabel.bottomAnchor, constant: 16),
            monthlyReportMetricsStack.leadingAnchor.constraint(equalTo: monthlyReportCard.leadingAnchor, constant: 16),
            monthlyReportMetricsStack.trailingAnchor.constraint(equalTo: monthlyReportCard.trailingAnchor, constant: -16),
            monthlyReportMetricsStack.bottomAnchor.constraint(equalTo: monthlyReportCard.bottomAnchor, constant: -16)
        ])
    }
    
    private func addMetricsToStack(_ stack: UIStackView, metrics: [(title: String, value: String, trend: String)]) {
        for metric in metrics {
            let metricView = createMetricView(title: metric.title, value: metric.value, trend: metric.trend)
            stack.addArrangedSubview(metricView)
        }
    }
    
    private func createMetricView(title: String, value: String, trend: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let trendLabel = UILabel()
        trendLabel.text = trend
        trendLabel.font = .systemFont(ofSize: 12)
        trendLabel.textColor = .systemGreen
        trendLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(valueLabel)
        view.addSubview(trendLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            trendLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            trendLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trendLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trendLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        // Simulate data refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
} 