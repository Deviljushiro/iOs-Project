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

    // MARK: - Action
    

    
    
    @IBAction func saveAction(_ sender: Any) {
        print("hello")
        guard (self.prenomLabel.text != "") && (self.nomLabel.text != "") && (self.motDePasse.text != "") && (self.confirmMotDePasse.text != "")
            else {
                DialogBoxHelper.alert(view: self, WithTitle: "Echec inscription", andMsg: "Informations manquantes")
                return }
        guard (self.motDePasse.text == self.confirmMotDePasse.text)
            else {
                DialogBoxHelper.alert(view: self, WithTitle: "Echec inscription", andMsg: "Confirmation incorrecte")
                return }
        self.performSegue(withIdentifier: "unwindToLoginAfterSaving", sender: self)
    }
    
   

    
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
