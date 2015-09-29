//
//  CarouselViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/24/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController, UIScrollViewDelegate {
    
    // Outlets & Vars ----------------------------------

    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var scrubberScrollView: UIScrollView!
    @IBOutlet weak var scrubberImageView: UIView!
    @IBOutlet weak var triggerImageButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fullScreenControlsView: UIView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerButton: UIButton!
    @IBOutlet weak var shareBackgroundView: UIView!
    @IBOutlet weak var shareActionSheet: UIView!
    @IBOutlet weak var checkmarkImageVIew: UIImageView!
    
    let linkCopiedController = UIAlertController(title: "Link Copied", message: nil, preferredStyle: .Alert)
    
    
    // Default Functions -------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (defaults.boolForKey("isTask1Complete") && defaults.boolForKey("isTask2Complete") && defaults.boolForKey("isTask3Complete")) || defaults.boolForKey("didUserHideBanner") {
            feedScrollView.contentInset.top = 0
            bannerView.hidden = true
        } else {
            feedScrollView.contentInset.top = 44
            bannerView.hidden = false
        }
        
        photoImageView.alpha = 0.0
        fullScreenControlsView.alpha = 0.0
        
        checkmarkImageVIew.alpha = 0.0
        
        feedScrollView.contentSize = feedImageView.image!.size
        scrubberScrollView.delegate = self
        scrubberScrollView.contentSize = CGSize(width: 640.0, height: 36.0)
        scrubberScrollView.contentOffset = CGPoint(x: 320, y: 0)
        
        shareBackgroundView.alpha = 0.0
        shareActionSheet.frame.origin.y = view.frame.height
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "linkCopied",
            name: "task3IsDone",
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Close Banner on Touch ---------------------------
    @IBAction func closeBannerButtonOnTouchUpInside(sender: AnyObject) {
        defaults.setBool(true, forKey: "didUserHideBanner")
        defaults.synchronize()
        liveUpdateBanner()
    }
    
    
    // Reveal Photo Full Screen UI ---------------------
    
    @IBAction func triggerImageOnTouchUpInside(sender: AnyObject) {
        showFullScreenView()
    }
    
    @IBAction func hideFullScreenButtonOnTouchUpInside(sender: AnyObject) {
        hideFullScreenView()
    }
    
    func showFullScreenView() {
        self.photoImageView.frame.size = self.triggerImageButton.frame.size
        self.photoImageView.center = (self.triggerImageButton.superview?.convertPoint(self.triggerImageButton.center, toView: self.view))!
        self.photoImageView.alpha = 1.0
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.fullScreenControlsView.alpha = 1.0
            self.photoImageView.frame.origin = CGPoint(x: 0, y: 0)
            self.photoImageView.frame.size = self.view.frame.size
            }, completion: {
                (value: Bool) in
                self.achievementUnlocked("isTask1Complete")
        })
    }
    
    func hideFullScreenView() {
        UIApplication.sharedApplication().statusBarStyle = .Default
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.fullScreenControlsView.alpha = 0.0
            self.photoImageView.frame.size = self.triggerImageButton.frame.size
            self.photoImageView.center = (self.triggerImageButton.superview?.convertPoint(self.triggerImageButton.center, toView: self.view))!
            }, completion: {
                (value: Bool) in
                self.photoImageView.alpha = 0.0
        })
    }
    
    
    // Scroll the scrubber -----------------------------
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        achievementUnlocked("isTask2Complete")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var maximumHorizontalOffset: CGFloat = scrubberScrollView.contentSize.width - CGRectGetWidth(scrubberScrollView.frame)
        var currentHorizontalOffset: CGFloat = scrubberScrollView.contentOffset.x
        var percentage: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        feedScrollView.contentOffset = CGPoint(x: 0, y: -feedScrollView.contentInset.top + percentage * (feedScrollView.contentSize.height - CGRectGetHeight(feedScrollView.frame) + feedScrollView.contentInset.top))
    }
    

    // Share Action Sheet ------------------------------
    
    @IBAction func showShareActionSheetOnTouchUpInside(sender: AnyObject) {
        showShareActionSheet()
    }
    
    @IBAction func hideShareActionSheetOnTouchUpInside(sender: AnyObject) {
        hideShareActionSheet()
    }
    
    func showShareActionSheet() {
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.shareBackgroundView.alpha = 0.3
            self.shareActionSheet.frame.origin.y = 158
            }, completion: nil)
    }
    
    func hideShareActionSheet() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.shareBackgroundView.alpha = 0.0
            self.shareActionSheet.frame.origin.y = self.view.frame.height
            }, completion: nil)
    }
    
    @IBAction func getLinkOnTouchUpInside(sender: AnyObject) {
        hideShareActionSheet()
        delay(0.3) { () -> () in
            UIApplication.sharedApplication().statusBarStyle = .Default
            self.performSegueWithIdentifier("segueCarouselToGetLink", sender: self)
        }
    }


    // Complete onboarding tasks ------------------------
    
    func achievementUnlocked(task: String) {
        if !defaults.boolForKey(task) {
            defaults.setBool(true, forKey: task)
            defaults.synchronize()
            checkmarkImageVIew.transform = CGAffineTransformMakeScale(1.2, 1.2)
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                self.checkmarkImageVIew.alpha = 1.0
                self.checkmarkImageVIew.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: nil)
            UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveLinear, animations: { () -> Void in
                self.checkmarkImageVIew.alpha = 0.0
                }, completion: nil)
        }
        
        liveUpdateBanner()
    }
    
    func liveUpdateBanner() {
        if (defaults.boolForKey("isTask1Complete") && defaults.boolForKey("isTask2Complete") && defaults.boolForKey("isTask3Complete")) || defaults.boolForKey("didUserHideBanner") {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.feedScrollView.contentInset.top = 0
                self.bannerView.alpha = 0.0
            })
        }
    }
    
    func linkCopied() {
        presentViewController(linkCopiedController, animated: true, completion: nil)
        delay(2.0, closure: { () -> () in
            self.linkCopiedController.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.achievementUnlocked("isTask3Complete")
            })
        })
    }

}
