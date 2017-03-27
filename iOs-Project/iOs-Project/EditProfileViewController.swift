//
//  EditProfileViewController.swift
//  iOs-Project
//
//  Created by JeanMi on 16/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class EditProfileViewController: KeyboardViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Constant
    
    let picker = UIImagePickerController()
    
    // MARK: - Variables
    
    var person: Personne? = nil
    
    // MARK: - Outlets
    
    @IBOutlet weak var EditProfileImage: UIImageView!
    @IBOutlet weak var EditProfileUsername: UILabel!
    @IBOutlet weak var TelTextField: UITextField!
    @IBOutlet weak var CityTextField: UITextField!
   

    // MARK: - View loading
    
    /// What the view has to load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.delegate = self
        if let aperson = self.person{
            self.EditProfileUsername.text = aperson.pseudo
            self.TelTextField.text = aperson.tel
            self.CityTextField.text = aperson.ville
            self.EditProfileImage.image = UIImage(data: aperson.photo as! Data)
        }
        
        //To tap the image
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.changeImage))
        self.EditProfileImage.addGestureRecognizer(tapImage)
        
        //Circle the image
        self.EditProfileImage.maskCircle(anyImage: self.EditProfileImage.image!)

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
