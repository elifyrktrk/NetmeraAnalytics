//
//  OnboardingPageContentViewController.swift
//  NetmeraAnalyticsApp
//
//  Created by Elif Yürektürk on 12.04.2025.
//

import UIKit

class OnboardingPageContentViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    var page: OnboardingPage?
    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PAGE DEBUG:")
            print("Title:", page?.title ?? "yok")
            print("Desc:", page?.description ?? "yok")
            print("Image:", page?.imageName ?? "yok")
        
               
        
        startButton.isHidden = true
        titleLabel.text = page?.title
        descriptionLabel.text = page?.description
        imageView.image = UIImage(named: page?.imageName ?? "")
    }
}
