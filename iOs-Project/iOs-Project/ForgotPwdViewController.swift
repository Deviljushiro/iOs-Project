 //
//  ForgotPwdViewController.swift
//  iOs-Project
//
//  Created by JeanMi on 19/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class ForgotPwdViewController: UIViewController {

    //MARK: - Outlet
    
    @IBOutlet weak var newpwd: UITextField!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var secretQ: UITextField!
    @IBOutlet weak var secretA: UITextField!
    
    //MARK: - Variables
    
    var person: Personne? = nil
    
    
    //MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Password data management
    
    
    /// Check the person has correctly input fields and change his pwd
    ///
    /// - Parameter sender: who send the action
    @IBAction func saveAction(_ sender: Any) {
        
        guard let user = id.text, user != "" , let npwd = self.newpwd.text, npwd != "" else {
            DialogBoxHelper.alert(view: self, WithTitle: "Modification impossible", andMsg: "Identifiant ou mot de passe manquant")
            return
        }
        let res = PersonnesSet.getPersonsByUsername(withUsername: user)
        if res == nil {
            DialogBoxHelper.alert(view: self, WithTitle: "Modification impossible", andMsg: "Identifiant inconnu")
            return
        }
        self.person = res!

        self.person?.mdp = self.newpwd.text
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    /// Cancel the action and go back to login
    ///
    /// - Parameter sender: wh send the action
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    

    



}
