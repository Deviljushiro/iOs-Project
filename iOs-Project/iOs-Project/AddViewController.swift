//
//  AddViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: KeyboardViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Constant
    
    let picker = UIImagePickerController()
    
    // MARK: - Variables
    
    var listPersons: PersonnesSet = PersonnesSet()
    var activeTextField = UITextField()
    
    // MARK: - Outlet
    
    @IBOutlet weak var nomLabel: UITextField!
    @IBOutlet weak var prenomLabel: UITextField!
    @IBOutlet weak var telLabel: UITextField!
    @IBOutlet weak var villeLabel: UITextField!
    @IBOutlet weak var image: UIImageView?
    @IBOutlet weak var motDePasse: UITextField!
    @IBOutlet weak var confirmMotDePasse: UITextField!
    @IBOutlet weak var promotion: UITextField!
    
    @IBOutlet weak var studentSwitch: UISwitch!
    @IBOutlet weak var secretartSwitch: UISwitch!
    @IBOutlet weak var teachSwitch: UISwitch!
    @IBOutlet weak var respoSwitch: UISwitch!

    
    // MARK: - View loading

    /// what the view has to load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        picker.delegate = self
        //Initialize switches & fields
        self.studentSwitch.isOn = false
        self.teachSwitch.isOn = false
        self.respoSwitch.isOn = false
        self.secretartSwitch.isOn = false
        self.promotion.isHidden = true

    }

    /// warning memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Image delegates
    
    /// Pick the image
    ///
    /// - Parameters:
    ///   - picker: picker which has to pick image
    ///   - info: about finish picking media
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image?.contentMode = .scaleAspectFit
            image?.image = chosenImage
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
    

    // MARK: - Action

    /// Enables switches & fields by selecting Student
    ///
    /// - Parameter sender: where comes from the action
    @IBAction func StudentActivation(_ sender: UISwitch) {
        if sender.isOn {
            self.respoSwitch.isEnabled = false
            self.teachSwitch.isEnabled = false
            self.secretartSwitch.isEnabled = false
            self.promotion.isHidden = false
        }
        else {
            self.respoSwitch.isEnabled = true
            self.teachSwitch.isEnabled = true
            self.secretartSwitch.isEnabled = true
            self.promotion.isHidden = true

        }
    }
    
    /// Enables switches & fields by selecting Secretaire
    ///
    /// - Parameter sender: where comes from the action
    @IBAction func SecreActivation(_ sender: UISwitch) {
        if sender.isOn {
            self.respoSwitch.isEnabled = false
            self.teachSwitch.isEnabled = false
            self.studentSwitch.isEnabled = false
        }
        else {
            self.respoSwitch.isEnabled = true
            self.teachSwitch.isEnabled = true
            self.studentSwitch.isEnabled = true
        }
    }
    
    /// Enables switches & fields by selecting Teacher
    ///
    /// - Parameter sender: where comes from the action
    @IBAction func TeacherActivation(_ sender: UISwitch) {
        if sender.isOn || self.respoSwitch.isOn {
            self.secretartSwitch.isEnabled = false
            self.studentSwitch.isEnabled = false
        }
        else {
            self.secretartSwitch.isEnabled = true
            self.studentSwitch.isEnabled = true
        }
    }
    
    
    /// Enables switches & fields by selecting Respo
    ///
    /// - Parameter sender: where comes from the action
    @IBAction func RespoActivation(_ sender: UISwitch) {
        if sender.isOn || self.teachSwitch.isOn {
            self.secretartSwitch.isEnabled = false
            self.studentSwitch.isEnabled = false
        }
        else {
            self.secretartSwitch.isEnabled = true
            self.studentSwitch.isEnabled = true
        }
    }

    
    /// Save the person by clicking on "Valider"
    ///
    /// - Parameter sender: who send action
    @IBAction func saveAction(_ sender: Any) {
        //create the attributes to save the new person
        
        //Image input
        var imageData: NSData
        if let image = self.image?.image {  //the image isn't empty
            imageData = UIImageJPEGRepresentation(image, 1)! as NSData
        }
        else {  //or it's empty
            imageData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "default"), 1)! as NSData
        }
        
        //switch input
        let isStudent = self.studentSwitch.isOn
        let isTeacher = self.teachSwitch.isOn
        let isSecretary = self.secretartSwitch.isOn
        let isRespo = self.respoSwitch.isOn
        
        //text input
        let firstname = self.prenomLabel.text ?? ""
        let lastname = self.nomLabel.text ?? ""
        let tel = self.telLabel.text ?? ""
        let city = self.villeLabel.text ?? ""
        let pwd = self.motDePasse.text ?? ""
        let promo = self.promotion.text ?? ""
        let pwd2 = self.confirmMotDePasse.text ?? ""
        
        //check input
        guard firstname != "" && lastname != "" && pwd != "" && pwd2 != "" else {
            DialogBoxHelper.alert(view: self, WithTitle: "Inscription impossible", andMsg: "Informations manquantes")
            return
        }
        //check password
        guard pwd == pwd2 else {
            DialogBoxHelper.alert(view: self, WithTitle: "Inscription impossible", andMsg: "Mots de passe non conformes")
            return
        }
        //save it
        Personne.createNewPersonne(firstName: firstname, name: lastname, tel: tel, city: city, pwd: pwd, image: imageData, isStudent: isStudent, isTeacher:  isTeacher, isSecretary: isSecretary, isRespo: isRespo, promo: promo)
        self.dismiss(animated: true, completion: nil)
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
