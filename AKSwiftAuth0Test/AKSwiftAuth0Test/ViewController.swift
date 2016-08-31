//
//  ViewController.swift
//  AKSwiftAuth0Test
//

import UIKit
import Lock

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.recieveMagicLink(_:)), name: A0LockNotificationUniversalLinkReceived, object: nil)
    }
    
    func recieveMagicLink(notification:NSNotification) {
        if let actualUserInfo = notification.userInfo, let link = actualUserInfo["com.auth0.universal-link.url"], let code = link.query {
            var codeValue = code!
            let range = codeValue.startIndex..<codeValue.startIndex.advancedBy(5)
            codeValue.removeRange(range)
            print("CODE : \(codeValue)")
            if (self.emailTextField.text?.characters.count < 1) {
                self.showMessage("You need to eneter email");
                return;
            }
            self.loginWithEmail(self.emailTextField.text!, code: codeValue)
         }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //CUSTOM UI
    @IBAction func clickSendEmailWithMagicLink(sender: AnyObject) {
        if (self.emailTextField.text?.characters.count < 1) {
            self.showMessage("You need to eneter email");
            return;
        }
        let client = A0Lock.sharedLock().apiClient()
        client.startPasswordlessWithMagicLinkInEmail(self.emailTextField.text!, parameters: A0AuthParameters.newDefaultParams(), success: {
            self.showMessage("Please check email \(self.emailTextField.text!)")
        }) { (error) in
            print("error : \(error)")
        }
    }
    
    func loginWithEmail(email:String, code: String) {
        A0Lock.sharedLock().apiClient().loginWithEmail(email, passcode: code, parameters: nil, success: { (profile: A0UserProfile!, token: A0Token!)in
            print("profile : \(profile)")
            dispatch_async(dispatch_get_main_queue()) {
                self.userNameLabel.text = profile.userId
                self.userIdLabel.text = profile.email
            }
            }, failure: { (error) in
                print("error : \(error)")
        })
    }
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    //LOCK UI
    @IBAction func clickEmailWithMagicLinkButton(sender: AnyObject) {
        self.authenticatiWithEmail(true)
    }

    @IBAction func clickEmailWithCodeButton(sender: AnyObject) {
        self.authenticatiWithEmail(false)
    }
    
    func authenticatiWithEmail(isMagicLink:Bool) {
        let lock = A0Lock.sharedLock()
        let controller = lock.newEmailViewController()
        controller.useMagicLink = isMagicLink
        controller.closable = true
        controller.onAuthenticationBlock = {(profile: A0UserProfile!, token: A0Token!) -> () in
            print("profile : \(profile)")
            dispatch_async(dispatch_get_main_queue()) {
                self.userNameLabel.text = profile.userId
                self.userIdLabel.text = profile.email
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        lock.presentEmailController(controller, fromController: self)
    }
    
    func showMessage(message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Auth0", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
