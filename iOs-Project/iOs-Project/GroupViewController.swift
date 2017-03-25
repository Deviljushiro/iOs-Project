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
    
    //MARK: - Variables
    
    var groupSet: GroupesSet = GroupesSet(person: Session.getSession());
    
    //MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view delegate protocol
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let group = self.groupSet.getGroups().object(at: indexPath)
        let cell = self.Groups.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! ListGroupTableViewCell
        //get the msg datas from the fetched msg
        cell.group.text = group.name
        return cell
    }
    
    
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
    
  
    let groupMessageSegueId = "groupMessageSegue"

    // MARK: - Navigation
    
    
    /// prepare to send datas to the group message view ctrler
    ///
    /// - Parameters:
    ///   - segue: the related segue to the other view
    ///   - sender: who send datas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.groupMessageSegueId{
            if let indexPath = self.Groups.indexPathForSelectedRow {
                let groupMessageViewController = segue.destination as! GroupMessageViewController
                groupMessageViewController.group = self.groupSet.getGroups().object(at: indexPath)
            }
        }
     }
    
}
