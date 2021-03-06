//
//  LoginViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 22/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: KeyboardViewController {
    
    // MARK: - Variables
    
    var listPersons : PersonnesSet!

    // MARK: - Outlets
    
    @IBOutlet weak var IdField: UITextField!
    @IBOutlet weak var PwdField: UITextField!
    @IBOutlet weak var Statement: UILabel!
    @IBOutlet weak var Welcome: UILabel!
    
    // MARK: - Table loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //create the default group concerning everybody if it doesn't already exist
        if GroupesSet.getGroupByName(groupName: "All") == nil {
            Groupe.createNewGroup(name: "All")
        }
        
        
        /** CORE DATA THAT NEEDS TO ALWAYS BE IN THE DB
            IN CASE OF NO LOCAL DB, WE HAVE TO INSERT THEM 
            LIKE THIS : **/
        
        //create the respo of the section (admin) each time someone use the app on a new devic
        if PersonnesSet.getPersonsByUsername(withUsername: "anne.laurent") == nil {
            Personne.createNewPersonne(firstName: "anne", name: "laurent", tel: "", city: "montpellier", pwd: "admin", image: UIImageJPEGRepresentation(#imageLiteral(resourceName: "default"), 1)! as NSData, isStudent: false, isTeacher: true, isSecretary: false, isRespo: true, promo: "")
        }
        //create the different keywords if there's no KW in the Core data
        if MotClefSet().getKW().fetchedObjects?.count == 0 {
            MotClef.createNewKeyword(word: "Documents")
            MotClef.createNewKeyword(word: "Medias")
            MotClef.createNewKeyword(word: "Administration")
            MotClef.createNewKeyword(word: "Divers")
        }

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
        
        guard let user = IdField.text, user != "" , let pwd = self.PwdField.text, pwd != ""   else {
            DialogBoxHelper.alert(view: self, WithTitle: "Connection impossible", andMsg: "Identifiant ou mot de passe manquant")
            return
        }
        let res = PersonnesSet.getPersonsByUsername(withUsername: user)
        if res == nil {
            DialogBoxHelper.alert(view: self, WithTitle: "Connection impossible", andMsg: "Identifiant inconnu")
            return
        }
        else {
            if res!.mdp != pwd {
                DialogBoxHelper.alert(view: self, WithTitle: "Connection impossible", andMsg: "Mot de passe erroné")
                return
            }
            else {
                //create a Session with the first value of the result
                Session.createSession(person: res!)
              //  if Session.getSession() != nil{
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
             //   }
            }
            
        }
    }
    

    
}
