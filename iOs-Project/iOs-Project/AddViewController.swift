//
//  AddViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Constant
    
    let picker = UIImagePickerController()
    
    // MARK: - Variables
    
    var person: Personne? = nil
    var listPersons: PersonnesSet = PersonnesSet()
    
    // MARK: - Outlet
    
    @IBOutlet weak var nomLabel: UITextField!
    @IBOutlet weak var prenomLabel: UITextField!
    @IBOutlet weak var telLabel: UITextField!
    @IBOutlet weak var villeLabel: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var motDePasse: UITextField!
    @IBOutlet weak var confirmMotDePasse: UITextField!
    
    // MARK: - View loading

    /// what the view has to load
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
    }

    /// warning memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates
    
    /// Pick the image
    ///
    /// - Parameters:
    ///   - picker: picker which has to pick image
    ///   - info: about finish picking media
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.contentMode = .scaleAspectFit
            image.image = chosenImage
            dismiss(animated:true, completion: nil)
        }
    }
    
    /// When clicking cancel, remove the picker
    ///
    /// - Parameter picker: The picker which has to be removed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
    // MARK: - Person data management
    
    /// create a new person, add it to the personsSet and save the context
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

    /// Save the person by clicking on "Valider"
    ///
    /// - Parameter sender: who send action
    @IBAction func saveAction(_ sender: Any) {
        //create the attributes to save the new person
        let firstname = self.prenomLabel.text ?? ""
        let lastname = self.nomLabel.text ?? ""
        let tel = self.telLabel.text ?? ""
        let city = self.villeLabel.text ?? ""
        let pwd = self.motDePasse.text ?? ""
        let pwd2 = self.confirmMotDePasse.text ?? ""
        let image = UIImageJPEGRepresentation(self.image.image!,1) as NSData? ?? nil
        //save it
        self.saveNewPerson(withLastName: lastname, andFirstname: firstname, andTel: tel, andCity: city, andPwd: pwd, andImage: image!)
        DialogBoxHelper.alert(view: self, WithTitle: "Inscription validée")
        performSegue(withIdentifier: "backToLoginSegue", sender: self)
    }

    
    
    /// Cancel the registration by clicking on "Annuler"
    ///
    /// - Parameter sender: who send action
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    
    /// Ask for a picture by clicking on the "Ajouter une image" button
    ///
    /// - Parameter sender: who send the action
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //  }

}
