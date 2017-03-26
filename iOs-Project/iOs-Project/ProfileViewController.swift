//
//  ProfileViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 15/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    // MARK: - Variables
    
    var person : Personne? = nil
    
    // MARK: - Outlet
    
    @IBOutlet weak var ProfileTitle: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var ProfileFirstname: UILabel!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileUsernameLabel: UILabel!
    @IBOutlet weak var ProfileUsername: UILabel!
    @IBOutlet weak var ProfileTelLabel: UILabel!
    @IBOutlet weak var ProfileTel: UILabel!
    @IBOutlet weak var ProfileCityLabel: UILabel!
    @IBOutlet weak var ProfileCity: UILabel!
    @IBOutlet weak var ProfilePromoLabel: UILabel!
    @IBOutlet weak var ProfilePromo: UILabel!
    @IBOutlet weak var editButton: UIButton!

    // MARK: - View loading
    
    /// what the view has to load
    override func viewDidLoad() {
        super.viewDidLoad()
        // check if a person has been set
        if let aperson = self.person{
            self.ProfileFirstname.text = aperson.prenom
            self.ProfileName.text = aperson.nom
            self.ProfileUsername.text = aperson.pseudo
            self.ProfileTel.text = aperson.tel
            self.ProfileCity.text = aperson.ville
            self.ProfileImage.image = UIImage(data: aperson.photo as! Data)
            self.ProfilePromo.text = aperson.promo?.annee
        }
        //Hide the edit button of the person isn't allowed to edit the profile of the page
        if (self.person?.pseudo)! == Session.getSession().pseudo || Session.getSession().isAdmin(){
            self.editButton.isEnabled = true
            self.editButton.isHidden = false
        }
        else{
            self.editButton.isEnabled = false
            self.editButton.isHidden = true
        }
    }

    /// if receive a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action
    
    
    
    /// Go to the previous page
    ///
    /// - Parameter sender: who send the action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /// go to the edition page
    ///
    /// - Parameter sender: who send the action
    @IBAction func editProfileAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.editProfileSegueId, sender: self)
    }
    
    
    /// When validation from the edit profile page, save and refresh
    ///
    /// - Parameter segue: segue where it comes from

    @IBAction func unwindToPersonAfterEditing(segue: UIStoryboardSegue) {
        CoreDataManager.save()
        self.viewDidLoad()
    }
    
    // MARK: - Navigation
     
     let editProfileSegueId = "editProfileSegue"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    /// prepare to send datas
    ///
    /// - Parameters:
    ///   - segue: the related segue where datas will be sent
    ///   - sender: who senf datas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.editProfileSegueId{
            let editProfileViewController = segue.destination as! EditProfileViewController
            editProfileViewController.person = self.person
        }
    }

}
