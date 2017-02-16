//
//  EditProfileViewController.swift
//  iOs-Project
//
//  Created by JeanMi on 16/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
   
    
    // MARK: - View loading
    
    /// What the view has to load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /// if receive memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button
    
      
    /// cancel the edition by clicking "Annuler"
    ///
    /// - Parameter sender: who send the action
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Alerts
    
    /// if an error happens
    ///
    /// - Parameters:
    ///   - error: type of error
    ///   - user: from who comes the error
    func alertError(errorMsg error: String, userInfo user: String = "") {
        let alert = UIAlertController(title: error, message: user, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
