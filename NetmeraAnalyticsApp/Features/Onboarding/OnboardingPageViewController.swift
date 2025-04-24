//
//  OnboardingPageViewController.swift
//  NetmeraAnalyticsApp
//
//  Created by Elif Yürektürk on 12.04.2025.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // Create pageControl programmatically
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .black
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.numberOfPages = 3
        pc.currentPage = 0
        return pc
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Sayfalarımızın içeriği burada
    let pages = [
        OnboardingPage(title: "Real-Time User Tracking",
                       description: "See the number of active users on your app instantly. Monitor spikes and patterns as they happen.",
                       imageName: "page1"),
        OnboardingPage(title: "In-Depth Event Analytics",
                       description: "Explore which events are triggered, when, and how often. Understand user behavior with detailed metrics.",
                       imageName: "page2"),
        OnboardingPage(title: "Push Notification Performance",
                       description: "Track open rates and delivery success of your notifications. Measure real engagement, not just delivery.",
                       imageName: "page3")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the page view controller first
        dataSource = self
        delegate = self

        // Set up initial page
        if let firstVC = viewControllerAt(index: 0) as? OnboardingPageContentViewController {
            setViewControllers([firstVC], direction: .forward, animated: true)
            firstVC.isLastPage = false // Ensure button is hidden on first page
        }
        
        // Add page control after setting up the content
        setupPageControl()
    }
    
    private func setupPageControl() {
        // Remove any existing constraints
        pageControl.removeFromSuperview()
        
        // Add the page control to the view hierarchy
        view.addSubview(pageControl)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 150),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Configure page control
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }

    // MARK: - Helper Methods
    
    private func viewControllerAt(index: Int) -> OnboardingPageContentViewController? {
        guard index >= 0 && index < pages.count else { return nil }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingContent") as? OnboardingPageContentViewController else {
            return nil
        }

        vc.page = pages[index]
        vc.isLastPage = (index == pages.count - 1) // Set isLastPage based on index
        return vc
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingPageContentViewController,
              let page = vc.page,
              let index = pages.firstIndex(where: { $0.title == page.title }) else { return nil }

        return viewControllerAt(index: index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingPageContentViewController,
              let page = vc.page,
              let index = pages.firstIndex(where: { $0.title == page.title }) else { return nil }

        return viewControllerAt(index: index + 1)
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
        if completed,
           let visibleVC = viewControllers?.first as? OnboardingPageContentViewController,
           let currentPage = visibleVC.page,
           let index = pages.firstIndex(where: { $0.title == currentPage.title }) {
            
            pageControl.currentPage = index
            visibleVC.isLastPage = (index == pages.count - 1)
        }
    }

    func goToLoginScreen() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }

    
    @IBAction func startTapped(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")

          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
              loginVC.modalPresentationStyle = .fullScreen
              present(loginVC, animated: true)
          }
    }

}

// Add extension for constraint priority
extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

