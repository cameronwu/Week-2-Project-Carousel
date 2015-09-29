//
//  ConversationsViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/24/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonOnTouchUpInside(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }
    
}
