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

    // MARK: - Table view protocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check if a person has been set
        if let aperson = self.person{
            self.ProfileFirstname.text = aperson.prenom
            self.ProfileName.text = aperson.nom
            self.ProfileUsername.text = aperson.pseudo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
