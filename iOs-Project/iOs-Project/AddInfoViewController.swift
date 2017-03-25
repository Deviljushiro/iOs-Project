//
//  AddInfoViewController.swift
//  iOs-Project
//
//  Created by JeanMi on 24/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class AddInfoViewController: KeyboardViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var titleField: UITextField!
    
    //MARK: - Constant
    
    let picker = UIImagePickerController()


    //MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.delegate = self
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
        //put blank image if there's not
        var photoData: NSData? = UIImageJPEGRepresentation(#imageLiteral(resourceName: "blank"), 1) as NSData?
        if let photo = self.picture.image {
            photoData = UIImageJPEGRepresentation(photo, 1)! as NSData?
        }
        //create the new info
        Information.createNewInfo(title: title, body: content, url: link, picture: photoData!)
        dismiss(animated: true, completion: nil)
    }
    
    
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
