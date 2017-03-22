//
//  GroupViewController.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 22/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var groupSet: GroupesSet = GroupesSet();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var Groups: UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        

        let groups = self.groupSet.getGroupsByUser(person: Session.getSession())
        
        
            let cell = self.Groups.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! ListGroupTableViewCell

        //get the msg datas from the fetched msg
        
        cell.group.text =  groups[indexPath.row].name
        return cell
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let groups = self.groupSet.getGroupsByUser(person: Session.getSession())
        return groups.count
    }
}
