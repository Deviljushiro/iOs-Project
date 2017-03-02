//
//  LoginViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 22/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    // MARK: - Variables
    
    var person : Personne? = nil

    // MARK: - Outlets
    
    @IBOutlet weak var IdField: UITextField!
    @IBOutlet weak var PwdField: UITextField!
    @IBOutlet weak var Statement: UILabel!
    @IBOutlet weak var Welcome: UILabel!
    
    // MARK: - Table loading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    
    /// Check the id and password and connect the user
    ///
    /// - Parameter sender: who send the action
    @IBAction func loginAction(_ sender: Any) {
        
        guard let id = IdField.text, id != "" , let pwd = self.PwdField.text, pwd != ""   else {
            DialogBoxHelper.alert(view: self, WithTitle: "Connection impossible", andMsg: "Identifiant ou mot de passe manquant")
            return
        }
        let res = Personne.getPersonsById(withId: id)
        if res.count < 1 {
            DialogBoxHelper.alert(view: self, WithTitle: "Connection impossible", andMsg: "Identifiant inconnu")
            return
        }
        else {
            if res[0].mdp != pwd {
                DialogBoxHelper.alert(view: self, WithTitle: "Connection impossible", andMsg: "Mot de passe erroné")
                return
            }
            else {
                self.person = res[0]
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            
        }
    }

    
    // MARK: - Navigation


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "loginSegue" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! WallViewController
            destController.person = self.person
        }
    }
    
}
