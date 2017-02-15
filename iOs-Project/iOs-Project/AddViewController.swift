//
//  AddViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlet
    
    @IBOutlet weak var nomLabel: UITextField!
    @IBOutlet weak var prenomLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    //MARK - Save and Cancel a new person
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    func saveNewPerson (withName nom: String, andFirstname prenom: String, andUsername pseudo: String){
        //get context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.alertError(errorMsg: "Impossible de valider cette personne", userInfo: "Raison inconnue")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        //create a person
        let person = Personne(context: context)
        person.nom = nom
        do{
            try context.save()
            self.listePersonnes.append(person)
        }
        catch let error as NSError{
            self.alertError(errorMsg: "\(error)", userInfo: "\(error.userInfo)")
        }
    }*/
    
    
    func alertError(errorMsg error: String, userInfo user: String = "") {
        let alert = UIAlertController(title: error, message: user, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }

}
