//
//  WallViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 22/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class WallViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var ListMessages: UITableView!
    @IBOutlet weak var MessageField: UITextField!
    @IBOutlet weak var SideView: UIView!
    @IBOutlet weak var Messages: UITableView!
    
    // MARK: - Variables
    
    var person : Personne? = nil
    var listMsg : MessagesSet = MessagesSet()
    
    // MARK: - Table loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view datasource protocol
    
    /// Define the cell of the tableview
    ///
    /// - Parameters:
    ///   - tableView: Tableview related
    ///   - indexPath: the index of each cell
    /// - Returns: the cell with the defined values
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.Messages.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! ListTableViewCellMessage
        return cell
    }
    
    /// Tell the number of sections
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.listMsg.numbersOfMessages
    }
    
    // MARK: - Message data management
    
    /// create a new message and save it
    ///
    /// - Parameters:
    ///     - message : the message which is sent
    func saveNewMessage(message mes : String ){
        
        guard self.listMsg.addMessage(message: mes, personne: person!) != nil else{
            DialogBoxHelper.alert(view: self, WithTitle: "Erreur dans l'ajout du message")
            return
        }        
    }
    

    
    // MARK: - Actions
    
    
    /// Log out the user
    ///
    /// - Parameter sender: who send the action
    @IBAction func logoutAction(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
        }
    
    
    /// Go to the admin page
    ///
    /// - Parameter sender: sender of the action
    @IBAction func adminAction(_ sender: Any) {
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