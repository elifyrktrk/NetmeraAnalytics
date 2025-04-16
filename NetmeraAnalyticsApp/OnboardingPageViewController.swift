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
        pc.translatesAutoresizingMaskIntoConstraints = false // Important for Auto Layout
        return pc
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
        
        // Add the programmatically created pageControl to the view
        view.addSubview(pageControl)
        
        // Set up constraints for the pageControl
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Kaydırılabilir sayfalar için dataSource'u tanımlıyoruz
        dataSource = self
        delegate = self
       
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        // İlk sayfa ne olacak?
        if let firstVC = viewControllerAt(index: 0) as? OnboardingPageContentViewController {
            setViewControllers([firstVC], direction: .forward, animated: true)
            // Handle initial visibility for the first page
            firstVC.startButton.isHidden = !(0 == pages.count - 1)
        }
        
    }

    // Belirli bir index'teki sayfayı bulur
    func viewControllerAt(index: Int) -> OnboardingPageContentViewController? {
        guard index >= 0 && index < pages.count else { return nil }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingContent") as? OnboardingPageContentViewController else {
            return nil
        }

        vc.page = pages[index]
        return vc
    }

    // Geriye doğru kaydırma yapılırsa
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingPageContentViewController,
              let page = vc.page,
              let index = pages.firstIndex(where: { $0.title == page.title }) else { return nil }

        return viewControllerAt(index: index - 1)
    }

    // İleriye doğru kaydırma yapılırsa
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingPageContentViewController,
              let page = vc.page,
              let index = pages.firstIndex(where: { $0.title == page.title }) else { return nil }

        return viewControllerAt(index: index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
           let visibleVC = viewControllers?.first as? OnboardingPageContentViewController,
           let currentPage = visibleVC.page,
           let index = pages.firstIndex(where: { $0.title == currentPage.title }) {
            
            // Update the pageControl's current page
            pageControl.currentPage = index
            
            // Show/hide start button based on whether it's the last page
            let isLastPage = index == pages.count - 1
            visibleVC.startButton.isHidden = !isLastPage
       
        }
    }

    func goToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
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

