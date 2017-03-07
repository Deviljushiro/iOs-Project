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
        self.listPersons = PersonnesSet()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Person data management
    
    /// Save an existing person
    func save(){
        //get context
        if let error = CoreDataManager.save(){
            DialogBoxHelper.alert(view: self, error: error)
        }
    }
    
    /// create a new person and save it
    ///
    /// - Parameters:
    ///     - nom: lastname of the person
    ///     - prenom: firstname of the person
    func saveNewPerson(withLastName nom: String, andFirstname prenom: String, andTel tel: String, andCity ville: String, andPwd mdp: String, andImage image: NSData){
        let person = Personne.createNewPersonne(firstName: prenom, name: nom, tel: tel, city: ville, pwd: mdp, image: image)
        if let error = CoreDataManager.save() {
            DialogBoxHelper.alert(view: self, error: error)
        }
        else {
            self.listPersons.addPerson(person: person)
        }
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
        let res = listPersons.getPersonsByUsername(withUsername: user)
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
                Session.newSession(username: user, password: pwd)
                if Session.session != nil{
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
                            }
            
        }
    }
    
    /// When datas need to be obtained from the previous page
    ///
    /// - Parameter segue: The segue related to the previous page
    @IBAction func unwindToLoginAfterSaving(segue: UIStoryboardSegue){
        let addController = segue.source as! AddViewController
        self.saveNewPerson(withLastName: addController.nomLabel.text!, andFirstname : addController.prenomLabel.text!, andTel :addController.telLabel.text!, andCity : addController.villeLabel.text!, andPwd : addController.motDePasse.text!, andImage : (UIImageJPEGRepresentation(addController.image.image!, 1) as NSData?)!)
        if let error = CoreDataManager.save(){
            DialogBoxHelper.alert(view: self, error: error)
        }
        else { DialogBoxHelper.alert(view: self, WithTitle: "Inscription validée") }
    }

    
    
    /// Go to the registration Segue
    ///
    /// - Parameter sender: who send the action
    @IBAction func registrationAction(_ sender: Any) {
        self.performSegue(withIdentifier: "registerSegue", sender: self)
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
