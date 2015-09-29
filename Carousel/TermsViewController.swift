//
//  TermsViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/26/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var termsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var termsWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL (string: "https://www.dropbox.com/terms?mobile=1");
        let requestObj = NSURLRequest(URL: url!);
        termsWebView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButtonOnTouchUpInside(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
