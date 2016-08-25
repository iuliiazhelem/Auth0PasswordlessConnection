//
//  ViewController.swift
//  AKSwiftAuth0Test
//

import UIKit
import Lock

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

