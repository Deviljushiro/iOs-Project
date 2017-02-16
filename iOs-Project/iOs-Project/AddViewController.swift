//
//  AddViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlet
    
    @IBOutlet weak var nomLabel: UITextField!
    @IBOutlet weak var prenomLabel: UITextField!
    @IBOutlet weak var telLabel: UITextField!
    @IBOutlet weak var villeLabel: UITextField!
    
    // MARK: - View loading

    /// what the view has to load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /// warning memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Text field methods
    
    /// if the keyboard has to disappear after Return
    ///
    /// - Parameter textField: related textfield
    /// - Returns: TRUE it has to go out, FALSE else
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Button
    
    /// Cancel the add by clicking "Annuler" button
    ///
    /// - Parameter sender: who send the action
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //  }

}
