//
//  GroupViewController.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 22/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var Groups: UITableView!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    //MARK: - Variables
    
    var groupSet: GroupesSet = GroupesSet(person: Session.getSession());
    
    //MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Enable the admin to click on admin button
        if Session.getSession().isAdmin(){
            self.adminButton.isEnabled = true
            self.adminButton.isHidden = false
        }
        else{
            self.adminButton.isEnabled = false
            self.adminButton.isHidden = true
        }
        //Get the profile pic and make it circle
        self.profilePic.image = UIImage(data: Session.getSession().photo as! Data)
        self.profilePic.maskCircle(anyImage: self.profilePic.image!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view delegate protocol

    /// Define the cell of the tableview
    ///
    /// - Parameters:
    ///   - tableView: Tableview related
    ///   - indexPath: the index of each cell
    /// - Returns: the cell with the defined values
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let group = self.groupSet.getGroups().object(at: indexPath)
        let cell = self.Groups.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! ListGroupTableViewCell
        //get the msg datas from the fetched msg
        if group.name!.hasPrefix("2") { //If this is a promo group under the year 3000
            cell.group.text = "Promotion "+group.name!
        }
        else {
            cell.group.text = group.name
        }
        return cell
    }
    
    /// Tell the number of sections (for a search or not)
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.groupSet.getGroups().sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }

    //MARK: - Actions
    
    
    /// Go back to the previous page
    ///
    /// - Parameter sender: who send the action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Go to the session profile page
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func myProfileAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.myProfileSegueId, sender: self)
    }
    
    
    /// Go to the info page
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func infoAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.infoSegueId, sender: self)
    }

    // MARK: - Navigation
    
    let groupMessageSegueId = "groupMessageSegue"
    let myProfileSegueId = "myProfileSegue"
    let infoSegueId = "infoSegue"

    
    /// prepare to send datas to the group message view ctrler
    ///
    /// - Parameters:
    ///   - segue: the related segue to the other view
    ///   - sender: who send datas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.myProfileSegueId {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.person = Session.getSession()
        }
        if segue.identifier == self.groupMessageSegueId{
            if let indexPath = self.Groups.indexPathForSelectedRow {
                let groupMessageViewController = segue.destination as! GroupMessageViewController
                groupMessageViewController.group = self.groupSet.getGroups().object(at: indexPath)
            }
        }
     }
    
}
