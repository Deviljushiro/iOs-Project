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
        picker.delegate = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    /// Before editing the text field
    ///
    /// - Parameter textfield: the text field
    func textFieldDidBeginEditing(textfield: UITextField){
        activeTextField = textfield
    }
    
    /// After edition of the text field
    ///
    /// - Parameter textField: related text field
    func textFieldDidEndEditing(textfield: UITextField){
        activeTextField = UITextField()
    }
    
    // MARK : - Keyboard
    
    /// Size the keyboard and scroll the page according to it
    ///
    /// - Parameter notification: notif which called the method
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.activeTextField.frame.origin.y >= keyboardSize.height {
                self.view.frame.origin.y = keyboardSize.height - self.activeTextField.frame.origin.y
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    /// Keyboard disappear
    ///
    /// - Parameter notification: notif which called the method
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    

    // MARK: - Action

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
