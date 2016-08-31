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
        print("notification : \(notification.userInfo)")
        if let actualUserInfo = notification.userInfo, let link = actualUserInfo["com.auth0.universal-link.url"], let code = link.query {
            print("LINK : \(link)")
            var codeValue = code!
            let range = codeValue.startIndex..<codeValue.startIndex.advancedBy(5)
            codeValue.removeRange(range)
            //You can use this code for login with email and passcode
            //A0Lock.sharedLock().apiClient().loginWithEmail(<email>, passcode: codeValue, parameters: nil, 
            //success: { (profile: A0UserProfile!, token: A0Token!)in
            //    print("profile : \(profile)")
            //    }, failure: { (error) in
            //        print("error : \(error)")
            //})
            print("CODE : \(codeValue)")
         }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
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
}
