//
//  AddInfoViewController.swift
//  iOs-Project
//
//  Created by JeanMi on 24/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class AddInfoViewController: KeyboardViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var docSwitch: UISwitch!
    @IBOutlet weak var medSwitch: UISwitch!
    @IBOutlet weak var admSwitch: UISwitch!
    @IBOutlet weak var divSwitch: UISwitch!
    
    //MARK: - Constant
    
    let picker = UIImagePickerController()


    //MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.picker.delegate = self
        //Initialize switches
        self.docSwitch.isOn = false
        self.medSwitch.isOn = false
        self.admSwitch.isOn = false
        self.divSwitch.isOn = false
    }

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
            picture?.contentMode = .scaleAspectFit
            picture?.image = chosenImage
            dismiss(animated:true, completion: nil)
        }
    }
    
    /// When clicking cancel, remove the picker
    ///
    /// - Parameter picker: The picker which has to be removed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    //MARK: - Actions
    
    
    /// Enables switches & fields by selecting Document
    ///
    /// - Parameter sender: where comes from the action
    @IBAction func docActivation(_ sender: UISwitch) {
        if sender.isOn {
            self.medSwitch.isEnabled = false
            self.admSwitch.isEnabled = false
            self.divSwitch.isEnabled = false
        }
        else {
            self.medSwitch.isEnabled = true
            self.admSwitch.isEnabled = true
            self.divSwitch.isEnabled = true
        }
    }
    
    /// Enables switches & fields by selecting Media
    ///
    /// - Parameter sender: where comes from the action
    @IBAction func medActivation(_ sender: UISwitch) {
        if sender.isOn {
            self.docSwitch.isEnabled = false
            self.admSwitch.isEnabled = false
            self.divSwitch.isEnabled = false
        }
        else {
            self.docSwitch.isEnabled = true
            self.admSwitch.isEnabled = true
            self.divSwitch.isEnabled = true
        }
    }
    
    /// Enables switches & fields by selecting Administratif
    ///
    /// - Parameter sender: where comes from the action
    @IBAction func admActivation(_ sender: UISwitch) {
        if sender.isOn {
            self.medSwitch.isEnabled = false
            self.docSwitch.isEnabled = false
            self.divSwitch.isEnabled = false
        }
        else {
            self.medSwitch.isEnabled = true
            self.docSwitch.isEnabled = true
            self.divSwitch.isEnabled = true
        }
    }
    
    /// Enables switches & fields by selecting Divers
    ///
    /// - Parameter sender: where comes from the action
    @IBAction func divActivation(_ sender: UISwitch) {
        if sender.isOn {
            self.medSwitch.isEnabled = false
            self.admSwitch.isEnabled = false
            self.docSwitch.isEnabled = false
        }
        else {
            self.medSwitch.isEnabled = true
            self.admSwitch.isEnabled = true
            self.docSwitch.isEnabled = true
        }
    }
    
    /// Go to the previous page
    ///
    /// - Parameter sender: who send the action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Save the input and add the information
    ///
    /// - Parameter sender: who send the action
    @IBAction func saveAction(_ sender: Any) {
        //check the fields
        guard let title = self.titleField.text, title != "", let content = self.body.text, content != "" else {
            DialogBoxHelper.alert(view: self, WithTitle: "Création impossible", andMsg: "Informations manquantes")
            return
        }
        let link = self.url.text ?? ""
        //check if there's a keyword selected
        if self.docSwitch.isOn || self.admSwitch.isOn || self.medSwitch.isOn || self.divSwitch.isOn {
            //put blank image if there's not
            var photoData: NSData? = UIImageJPEGRepresentation(#imageLiteral(resourceName: "blank"), 1) as NSData?
            if let photo = self.picture.image {
                photoData = UIImageJPEGRepresentation(photo, 1)! as NSData?
            }
            //create the new info according to the keyword selected
            if self.docSwitch.isOn {
                Information.createNewInfo(title: title, body: content, url: link, picture: photoData!, KW: "Documents")
                dismiss(animated: true, completion: nil)
            }
            else if self.medSwitch.isOn {
                Information.createNewInfo(title: title, body: content, url: link, picture: photoData!, KW: "Medias")
                dismiss(animated: true, completion: nil)
            }
            else if self.admSwitch.isOn {
                Information.createNewInfo(title: title, body: content, url: link, picture: photoData!, KW: "Administration")
                dismiss(animated: true, completion: nil)
            }
            else {
                Information.createNewInfo(title: title, body: content, url: link, picture: photoData!, KW: "Divers")
                dismiss(animated: true, completion: nil)
            }
            
        }
        else {
            DialogBoxHelper.alert(view: self, WithTitle: "Création impossible", andMsg: "Mot clef manquant")
            return
        }
    }
    
    
    /// open the library by clicking on the file button
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
