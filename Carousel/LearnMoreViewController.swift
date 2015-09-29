//
//  LearnMoreViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/26/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class LearnMoreViewController: UIViewController {

    @IBOutlet weak var task1Checkbox: UIImageView!
    @IBOutlet weak var task2Checkbox: UIImageView!
    @IBOutlet weak var task3Checkbox: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // If task 1 is complete, show checkbox. Otherwise, hide it.
        if defaults.boolForKey("isTask1Complete") {
            task1Checkbox.hidden = false
        } else {
            task1Checkbox.hidden = true
        }
        
        // If task 2 is complete, show checkbox. Otherwise, hide it.
        if defaults.boolForKey("isTask2Complete") {
            task2Checkbox.hidden = false
        } else {
            task2Checkbox.hidden = true
        }
        
        // If task 3 is complete, show checkbox. Otherwise, hide it.
        if defaults.boolForKey("isTask3Complete") {
            task3Checkbox.hidden = false
        } else {
            task3Checkbox.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButtonOnTouchUpInside(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
