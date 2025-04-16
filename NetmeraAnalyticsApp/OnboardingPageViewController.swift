//
//  OnboardingPageViewController.swift
//  NetmeraAnalyticsApp
//
//  Created by Elif Yürektürk on 12.04.2025.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
//    @IBOutlet weak var pageControl: UIPageControl!
    
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
        
        // Kaydırılabilir sayfalar için dataSource'u tanımlıyoruz
        dataSource = self
        delegate = self
       
        
//        pageControl.numberOfPages = pages.count
//        pageControl.currentPage = 0
//        pageControl.pageIndicatorTintColor = .lightGray
//        pageControl.currentPageIndicatorTintColor = .black

        // İlk sayfa ne olacak?
        if let firstVC = viewControllerAt(index: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true)
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

            let isLastPage = index == pages.count - 1
            visibleVC.startButton.isHidden = !isLastPage
//            pageControl.currentPage = index
        
    
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

