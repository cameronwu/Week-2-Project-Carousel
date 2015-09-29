//
//  GetLinkViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/28/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class GetLinkViewController: UIViewController {

    @IBOutlet weak var getLinkScrollView: UIScrollView!
    @IBOutlet weak var getLinkImageView: UIImageView!
    @IBOutlet weak var shareMethodsScrollView: UIScrollView!
    @IBOutlet weak var shareMethodsImageView: UIImageView!
    
    let linkCopiedController = UIAlertController(title: "Link Copied in...", message: nil, preferredStyle: .Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLinkScrollView.contentSize = getLinkImageView.image!.size
        shareMethodsScrollView.contentSize = shareMethodsImageView.image!.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func copyLinkOnTouchUpInside(sender: AnyObject) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName("task3IsDone", object: nil)
        })
    }
    
    
    @IBAction func closeButtonOnTouchUpInside(sender: AnyObject) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        dismissViewControllerAnimated(true, completion: nil)
    }
}
