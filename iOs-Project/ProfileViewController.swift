//
//  ProfileViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 15/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

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
        }
    }

    /// if receive a memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button
    

    /// go to the edition page
    ///
    /// - Parameter sender: who send the action
    @IBAction func editProfileAction(_ sender: Any) {
        self.performSegue(withIdentifier: "editProfileSegue", sender: self)
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
