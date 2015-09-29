//
//  WelcomeViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/24/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var welcomeScrollView: UIScrollView!
    @IBOutlet weak var welcomePageControl: UIPageControl!
    @IBOutlet weak var backupButtonView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeScrollView.contentSize = CGSize(width: 1280, height: 568)
        welcomeScrollView.delegate = self
        
        backupButtonView.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // Get the current page based on the scroll offset
        var page: Int = Int(round(scrollView.contentOffset.x / 320))
        
        // Set the current page, so the dots will update
        welcomePageControl.currentPage = page

        if page == 3 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.backupButtonView.alpha = 1.0
            })
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.backupButtonView.alpha = 0.0
            })
        }
    }
    
}
