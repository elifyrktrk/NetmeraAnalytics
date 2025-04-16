import UIKit

class ContainerViewController: UIViewController {
    
    // MARK: - Properties
    private let mainViewController: UIViewController
    private let menuViewController: SideMenuViewController
    private var isMenuVisible = false
    private let menuWidth: CGFloat = 300
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimmedViewTap))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    // MARK: - Initialization
    init(mainViewController: UIViewController) {
        self.mainViewController = mainViewController
        self.menuViewController = SideMenuViewController()
        super.init(nibName: nil, bundle: nil)
        self.menuViewController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        print("Setting up ContainerViewController")
        
        addChild(mainViewController)
        view.addSubview(mainViewController.view)
        mainViewController.didMove(toParent: self)
        mainViewController.view.frame = view.bounds
        
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        view.addSubview(dimmedView)
        
        menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.bounds.height)
        
        dimmedView.frame = view.bounds
        dimmedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        print("ContainerViewController setup complete")
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Menu Actions
    func toggleMenu() {
        print("Toggle menu called, current state: \(isMenuVisible)")
        isMenuVisible ? hideMenu() : showMenu()
    }
    
    private func showMenu() {
        print("Showing menu")
        UIView.animate(withDuration: 0.3) {
            self.menuViewController.view.frame.origin.x = 0
            self.dimmedView.alpha = 0.6
        } completion: { _ in
            print("Menu shown")
        }
        isMenuVisible = true
    }
    
    private func hideMenu() {
        print("Hiding menu")
        UIView.animate(withDuration: 0.3) {
            self.menuViewController.view.frame.origin.x = -self.menuWidth
            self.dimmedView.alpha = 0
        } completion: { _ in
            print("Menu hidden")
        }
        isMenuVisible = false
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleDimmedViewTap() {
        hideMenu()
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            if isMenuVisible {
                let newX = max(-menuWidth, min(0, translation.x))
                menuViewController.view.frame.origin.x = newX
                dimmedView.alpha = 0.6 * (1 + newX / menuWidth)
            } else {
                let newX = max(-menuWidth, min(0, -menuWidth + translation.x))
                if translation.x > 0 {
                    menuViewController.view.frame.origin.x = newX
                    dimmedView.alpha = 0.6 * (1 + newX / menuWidth)
                }
            }
            
        case .ended:
            let velocity = gesture.velocity(in: view)
            if isMenuVisible {
                if velocity.x < -50 || translation.x < -menuWidth/2 {
                    hideMenu()
                } else {
                    showMenu()
                }
            } else {
                if velocity.x > 50 || translation.x > menuWidth/2 {
                    showMenu()
                } else {
                    hideMenu()
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - SideMenuDelegate
extension ContainerViewController: SideMenuDelegate {
    func didSelectMenuItem(title: String) {
        // Handle menu item selection
        switch title {
        case "Home":
            // Already on home/dashboard
            break
        case "Realtime":
            let realtimeVC = UIViewController() // Replace with your RealtimeViewController
            realtimeVC.title = "Realtime"
            navigateToViewController(realtimeVC)
        case "Dashboard":
            let dashboardVC = DashboardViewController()
            navigateToViewController(dashboardVC)
        case "Insights":
            let insightsVC = UIViewController() // Replace with your InsightsViewController
            insightsVC.title = "Insights"
            navigateToViewController(insightsVC)
        case "Reports snapshot":
            let reportsVC = UIViewController() // Replace with your ReportsViewController
            reportsVC.title = "Reports"
            navigateToViewController(reportsVC)
        case "Life cycle":
            let lifecycleVC = UIViewController() // Replace with your LifecycleViewController
            lifecycleVC.title = "Life Cycle"
            navigateToViewController(lifecycleVC)
        case "User":
            let userVC = UIViewController() // Replace with your UserViewController
            userVC.title = "User"
            navigateToViewController(userVC)
        case "Help":
            // Open help section
            break
        case "Feedback":
            // Open feedback form
            break
        case "Settings":
            let settingsVC = UIViewController() // Replace with your SettingsViewController
            settingsVC.title = "Settings"
            navigateToViewController(settingsVC)
        default:
            break
        }
        
        // Hide menu after selection
        hideMenu()
    }
    
    private func navigateToViewController(_ viewController: UIViewController) {
        if let navigationController = mainViewController as? UINavigationController {
            navigationController.setViewControllers([viewController], animated: false)
        }
    }
} 