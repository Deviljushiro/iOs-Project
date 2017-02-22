//
//  EditProfileViewController.swift
//  iOs-Project
//
//  Created by JeanMi on 16/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Variables
    
    var person: Personne? = nil
    
    // MARK: - Outlets
    
    @IBOutlet weak var EditProfileTitle: UILabel!
    @IBOutlet weak var EditProfileImage: UIImageView!
    @IBOutlet weak var EditProfileFirstnameLabel: UILabel!
    @IBOutlet weak var EditProfileNameLabel: UILabel!
    @IBOutlet weak var EditProfileUsernameLabel: UILabel!
    @IBOutlet weak var EditProfileUsername: UILabel!
    @IBOutlet weak var EditProfileTelLabel: UILabel!
    @IBOutlet weak var EditProfileCityLabel: UILabel!
    
    
    @IBOutlet weak var FirstnameTextField: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var TelTextField: UITextField!
    @IBOutlet weak var CityTextField: UITextField!
   

    // MARK: - View loading
    
    /// What the view has to load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let aperson = self.person{
            self.EditProfileUsername.text = aperson.pseudo
            self.FirstnameTextField.text = aperson.prenom
            self.NameTextField.text = aperson.nom
            self.TelTextField.text = aperson.tel
            self.CityTextField.text = aperson.ville
            
        }
        
    }

    /// if receive memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    
    /// Save new fields by clicking "Valider"
    ///
    /// - Parameter sender: who send action
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        guard let person = self.person else { return }
        guard (self.FirstnameTextField.text != "") && (self.NameTextField.text != "")
        else {
            DialogBoxHelper.alert(view: self, WithTitle: "Echec modification", andMsg: "Prénom ou nom manquant")
            return }
        person.prenom = self.FirstnameTextField.text
        person.nom = self.NameTextField.text
        person.tel = self.TelTextField.text
        person.ville = self.CityTextField.text
        self.performSegue(withIdentifier: segueUnwindId, sender: self)
    }
      
    /// cancel the edition by clicking "Annuler"
    ///
    /// - Parameter sender: who send the action
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    let segueUnwindId = "unwindToPersonAfterEditing"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}

}
