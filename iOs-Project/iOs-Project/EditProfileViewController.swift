//
//  EditProfileViewController.swift
//  iOs-Project
//
//  Created by JeanMi on 16/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Constant
    
    let picker = UIImagePickerController()
    
    // MARK: - Variables
    
    var person: Personne? = nil
    var activeTextField = UITextField()
    
    // MARK: - Outlets
    
    @IBOutlet weak var EditProfileTitle: UILabel!
    @IBOutlet weak var EditProfileImage: UIImageView!
    @IBOutlet weak var EditProfileFirstnameLabel: UILabel!
    @IBOutlet weak var EditProfileNameLabel: UILabel!
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
        picker.delegate = self
        if let aperson = self.person{
            self.FirstnameTextField.text = aperson.prenom
            self.NameTextField.text = aperson.nom
            self.TelTextField.text = aperson.tel
            self.CityTextField.text = aperson.ville
            self.EditProfileImage.image = UIImage(data: aperson.photo as! Data)
        }
        //to tap the image
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.changeImage))
        self.EditProfileImage.addGestureRecognizer(tapImage)
        //notif for the kayboard management
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    

    /// if receive memory warning
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
            self.EditProfileImage.contentMode = .scaleAspectFit
            self.EditProfileImage.image = chosenImage
            dismiss(animated:true, completion: nil)
        }
    }
    
    /// When clicking cancel, remove the picker
    ///
    /// - Parameter picker: The picker which has to be removed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Action
    
    /// open the photo library by clicking on the picture
    ///
    /// - Parameter sender: who send the action
    func changeImage(sender: UITapGestureRecognizer){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
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
        person.photo = UIImageJPEGRepresentation(self.EditProfileImage.image!,1)! as NSData
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
