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
    var listMsg: [Message] = []
    
    // MARK: - Table loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the context
        let context = CoreDataManager.getContext()
        //create query related to the Personne entity
        let request : NSFetchRequest<Message> = Message.fetchRequest()
        do {
            try self.listMsg = context.fetch(request)
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
            return
        }
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
        let cell = self.Messages.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! ListTableViewCell
        return cell
    }
    
    /// Tell the number of sections
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.listMsg.count
    }
    
    // MARK: - Message data management
    
    /// create a new message and save it
    ///
    /// - Parameters:
    ///     - message : the message which is sent
    func saveNewMessage(message mes : String ){
        //get the context
        //get the context
        let context = CoreDataManager.getContext()
        //create a person
        let message = Message(context: context)
        //save datas into the person
        message.contenu = mes
        message.dateEnvoi = currentDate() as NSDate
        if let error = CoreDataManager.save() {
            DialogBoxHelper.alert(view: self, error: error)
        }
        
    }
    
    
    // MARK: - Functions
    
    func currentDate() -> Date{
        let date = NSDate()
        let calendar = NSCalendar.current
        let dateNeeded = calendar.dateComponents([.year, .month,.day], from: date as Date)
        let year = String(describing: dateNeeded.year)
        let month = String(describing:dateNeeded.month)
        let day = String(describing:dateNeeded.day)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let result = formatter.date(from :day+"/"+month+"/"+year)
        return result!
        
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
