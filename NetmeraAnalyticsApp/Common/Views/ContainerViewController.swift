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
        
        // Configure navigation bar appearance for the entire app
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        addChild(mainViewController)
        view.addSubview(mainViewController.view)
        mainViewController.didMove(toParent: self)
        mainViewController.view.frame = view.bounds
        
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        view.addSubview(dimmedView)
        
        menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.bounds.height)
        
        dimmedView.frame = CGRect(x: menuWidth, y: 0, width: view.bounds.width - menuWidth, height: view.bounds.height)
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
            let dashboardVC = DashboardViewController()
            navigateToViewController(dashboardVC)
        case "Realtime":
            let realtimeVC = RealtimeViewController()
            navigateToViewController(realtimeVC)
        case "Dashboard":
            let dashboardVC = DashboardViewController()
            navigateToViewController(dashboardVC)
        case "Insights":
            let insightsVC = InsightsViewController()
            navigateToViewController(insightsVC)
        case "Reports snapshot":
            let reportsVC = ReportsViewController()
            navigateToViewController(reportsVC)
        case "Life cycle":
            let lifecycleVC = LifecycleViewController()
            navigateToViewController(lifecycleVC)
        case "User":
            let userVC = UserViewController()
            navigateToViewController(userVC)
        case "Test Netmera":
            let testNetmeraVC = TestNetmeraViewController()
            navigateToViewController(testNetmeraVC)
        case "Help":
            let helpVC = HelpViewController()
            navigateToViewController(helpVC)
        case "Feedback":
            let feedbackVC = FeedbackViewController()
            navigateToViewController(feedbackVC)
        case "Settings":
            let settingsVC = SettingsViewController()
            // Don't create a new navigation controller, just push the view controller
            navigateToViewController(settingsVC)
        default:
            break
        }
        
        // Hide menu after selection
        hideMenu()
    }
    
    private func navigateToViewController(_ viewController: UIViewController) {
        if let navigationController = mainViewController as? UINavigationController {
            // If the view controller is already in the navigation stack, just pop to it
            if let existingVC = navigationController.viewControllers.first(where: { $0.isKind(of: type(of: viewController)) }) {
                navigationController.popToViewController(existingVC, animated: true)
            } else {
                // Otherwise, push the new view controller
                navigationController.setNavigationBarHidden(false, animated: true)
                
                // Set up back button for the view controller being pushed
                if navigationController.viewControllers.count > 0 {
                    let backButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(menuButtonTapped))
                    viewController.navigationItem.leftBarButtonItem = backButton
                }
                
                navigationController.pushViewController(viewController, animated: true)
            }
            
            // Ensure the navigation bar is visible
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @objc private func menuButtonTapped() {
        toggleMenu()
    }
} 