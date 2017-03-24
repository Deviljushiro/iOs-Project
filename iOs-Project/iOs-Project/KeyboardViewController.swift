//
//  KeyboardViewController.swift
//  iOs-Project
//
//  Created by Jean Miquel on 24/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import UIKit


/* Each controller needing keyboard management will heritate from this instead of UIViewController */

class KeyboardViewController: UIViewController {

    
    
    //MARK: - View loading + Notifications
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Notifications to manage the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    // MARK : - Keyboard
    
    /// Size the keyboard and scroll the page according to it
    ///
    /// - Parameter notification: notif which called the method
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 180
            }
        }
    }
    
    /// Keyboard disappear
    ///
    /// - Parameter notification: notif which called the method
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

}
