//
//  CreateAccountViewController.swift
//  Carousel
//
//  Created by Cameron Wu on 9/26/15.
//  Copyright © 2015 Cameron Wu. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    // Outlets -----------------------------------------
    
    @IBOutlet weak var termsCheckboxButton: UIButton!
    @IBOutlet weak var createAccountScrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var createButtonView: UIView!
    
    var isTermsSelected = false
    var createButtonInitialY: CGFloat!
    
    
    // Alerts ------------------------------------------
    
    let emptyFirstNameController = UIAlertController(title: "First Name Required", message: "Please enter your first name.", preferredStyle: .Alert)
    let emptyLastNameController = UIAlertController(title: "Last Name Required", message: "Please enter your last name.", preferredStyle: .Alert)
    let emptyEmailController = UIAlertController(title: "Email Required", message: "Please enter your email address.", preferredStyle: .Alert)
    let emptyPasswordController = UIAlertController(title: "Password Required", message: "Please enter your password.", preferredStyle: .Alert)
    let creatingingYourDropboxController = UIAlertController(title: "Creating your Dropbox...", message: nil, preferredStyle: .Alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)

    
    // Default Functions -------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        createButtonInitialY = createButtonView.frame.origin.y
        createAccountScrollView.contentSize = CGSize(width: 320, height: 502)
        
        createAccountScrollView.alpha = 0.0
        createAccountScrollView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.3, delay: 0.2, options: .CurveEaseOut, animations: { () -> Void in
            self.createAccountScrollView.alpha = 1.0
            self.createAccountScrollView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        emptyFirstNameController.addAction(OKAction)
        emptyLastNameController.addAction(OKAction)
        emptyEmailController.addAction(OKAction)
        emptyPasswordController.addAction(OKAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Button Actions ----------------------------------
    
    @IBAction func backButtonOnTouchUpInside(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //self.createAccountScrollView.scrollEnabled = false
        UIView.animateWithDuration(0.2) { () -> Void in
            self.createAccountScrollView.contentOffset = CGPoint(x: 0, y: 105)
        }
        return true
    }

    @IBAction func termsCheckboxButtonOnTouchUpInside(sender: AnyObject) {
        if (isTermsSelected) {
            termsCheckboxButton.selected = false
            isTermsSelected = false
        } else {
            termsCheckboxButton.selected = true
            isTermsSelected = true
        }
    }
    
    @IBAction func createButtonOnTouchUpInside(sender: AnyObject) {
        if firstNameTextField.text == "" {
            // First name is empty!
            presentViewController(emptyFirstNameController, animated: true) {}
        } else if lastNameTextField.text == "" {
            // Last name is empty!
            presentViewController(emptyLastNameController, animated: true) {}
        } else if emailTextField.text == "" {
            // Email is empty!
            presentViewController(emptyEmailController, animated: true) {}
        } else if passwordTextField.text == "" {
            // Password is empty!
            presentViewController(emptyPasswordController, animated: true) {}
        } else {
            // All fields are filled in
            if termsCheckboxButton.selected == true {
                // Terms are accepted
                presentViewController(creatingingYourDropboxController, animated: true) {
                    delay(2.0, closure: { () -> () in
                        // Reset onboarding for new user
                        defaults.setBool(false, forKey: "isTask1Complete")
                        defaults.setBool(false, forKey: "isTask2Complete")
                        defaults.setBool(false, forKey: "isTask3Complete")
                        defaults.setBool(false, forKey: "didUserHideBanner")
                        defaults.synchronize()
                        // Segue to welcome screen
                        self.creatingingYourDropboxController.dismissViewControllerAnimated(true, completion: nil)
                        self.performSegueWithIdentifier("segueCreateToWelcome", sender: nil)
                    })
                }
            } else {
                // Terms have not been accepted
                let anim = CAKeyframeAnimation( keyPath:"transform" )
                anim.values = [
                    NSValue( CATransform3D:CATransform3DMakeTranslation(-8, 0, 0 ) ),
                    NSValue( CATransform3D:CATransform3DMakeTranslation( 8, 0, 0 ) )
                ]
                anim.autoreverses = true
                anim.repeatCount = 2
                anim.duration = 7/100
                
                termsView.layer.addAnimation(anim, forKey: nil)
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
                self.createButtonView.frame.origin.y = self.createButtonInitialY
                self.createAccountScrollView.contentInset.bottom = 0
                self.createAccountScrollView.contentSize = CGSize(width: 320, height: 502)
                self.createAccountScrollView.contentOffset = CGPoint(x: 0, y: 0)
            }, completion: nil)
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
                self.createButtonView.frame.origin.y = self.createButtonInitialY - 70
                self.createAccountScrollView.contentInset.bottom = kbSize.height
                self.createAccountScrollView.contentSize = CGSize(width: 320, height: 386)
                self.createAccountScrollView.contentOffset = CGPoint(x: 0, y: 105)
            }, completion: nil)
    }
    
}
