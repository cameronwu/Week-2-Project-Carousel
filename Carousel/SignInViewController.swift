//
//  SignInViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/23/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // Outlets & Vars ----------------------------------
    
    @IBOutlet weak var signInScrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInFieldsView: UIView!
    @IBOutlet weak var signInButtonsView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    var signInButtonsInitialY: CGFloat!
    
    var initialFieldsY: CGFloat!
    let offsetFields: CGFloat! = -100
    var initialButtonsY: CGFloat!
    let offsetButtons: CGFloat! = -216
    
    
    // Alerts ------------------------------------------
    
    let emptyEmailController = UIAlertController(title: "Email Required", message: "Please enter your email address", preferredStyle: .Alert)
    let emptyPasswordController = UIAlertController(title: "Password Required", message: "Please enter your password", preferredStyle: .Alert)
    let signInFailedController = UIAlertController(title: "Sign In Failed", message: "Incorrect email or password", preferredStyle: .Alert)
    let signingInController = UIAlertController(title: "Signing in...", message: nil, preferredStyle: .Alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    
    
    // Default Functions -------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialFieldsY = signInFieldsView.frame.origin.y
        initialButtonsY = signInButtonsView.frame.origin.y
        
        signInButtonsInitialY = signInButtonsView.frame.origin.y
        signInScrollView.contentSize = CGSize(width: 320, height: 502)
        
        signInScrollView.alpha = 0.0
        signInScrollView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.3, delay: 0.2, options: .CurveEaseOut, animations: { () -> Void in
            self.signInScrollView.alpha = 1.0
            self.signInScrollView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        emptyEmailController.addAction(OKAction)
        emptyPasswordController.addAction(OKAction)
        signInFailedController.addAction(OKAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Button Actions ----------------------------------
    
    @IBAction func backButtonOnTouchUpInside(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func signInButtonOnTouchUpInside(sender: AnyObject) {
        if emailTextField.text == "" {
            // Email is empty!
            presentViewController(emptyEmailController, animated: true) {}
        } else if passwordTextField.text == "" {
            // Password is empty!
            presentViewController(emptyPasswordController, animated: true) {}
        } else {
            // Neither are empty
            if emailTextField.text == "tim@codepath.com" && passwordTextField.text == "password" {
                // Sign in successful
                presentViewController(signingInController, animated: true) {
                    delay(2.0, closure: { () -> () in
                        self.signingInController.dismissViewControllerAnimated(true, completion: nil)
                        self.performSegueWithIdentifier("segueSignInToWelcome", sender: nil)
                    })
                }
            } else {
                // Sign in failed
                presentViewController(signingInController, animated: true) {
                    delay(2.0, closure: { () -> () in
                        //self.signingInController.dismissViewControllerAnimated(true, completion: nil)
                        //self.presentViewController(self.signInFailedController, animated: true, completion: nil)
                        self.signingInController.dismissViewControllerAnimated(true, completion: { () -> Void in
                            self.presentViewController(self.signInFailedController, animated: true, completion: nil)
                        })
                    })
                }
            }
        }
    }
    
    
    // Keyboard Hide/Show Functions --------------------
    
    func keyboardWillHide(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        // Get the keyboard height and width from the notification
        // Size varies depending on OS, language, orientation
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
        var durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        var animationDuration = durationValue.doubleValue
        var curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        var animationCurve = curveValue.integerValue
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.signInButtonsView.frame.origin.y = self.signInButtonsInitialY
            self.signInScrollView.contentInset.bottom = 0
            self.signInScrollView.contentSize = CGSize(width: 320, height: 502)
            self.signInScrollView.contentOffset = CGPoint(x: 0, y: 0)
            }, completion: nil)
        /*UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
                self.signInFieldsView.frame.origin = CGPoint(x: self.signInFieldsView.frame.origin.x, y: self.initialFieldsY)
                self.signInButtonsView.frame.origin = CGPoint(x: self.signInButtonsView.frame.origin.x, y: self.initialButtonsY)
            }, completion: nil)*/
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        // Get the keyboard height and width from the notification
        // Size varies depending on OS, language, orientation
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
        var durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        var animationDuration = durationValue.doubleValue
        var curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        var animationCurve = curveValue.integerValue
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.signInButtonsView.frame.origin.y = self.signInButtonsInitialY - 117
            self.signInScrollView.contentInset.bottom = kbSize.height
            self.signInScrollView.contentSize = CGSize(width: 320, height: 386)
            self.signInScrollView.contentOffset = CGPoint(x: 0, y: 105)
            }, completion: nil)
        /*UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions(rawValue: UInt(animationCurve << 16)), animations: {
            self.signInFieldsView.frame.origin = CGPoint(x: self.signInFieldsView.frame.origin.x, y: self.initialFieldsY + self.offsetFields)
            self.signInButtonsView.frame.origin = CGPoint(x: self.signInButtonsView.frame.origin.x, y: self.initialButtonsY + self.offsetButtons)
            }, completion: nil)*/
    }
    
}
