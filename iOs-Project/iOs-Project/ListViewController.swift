//
//  ListViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {


    // MARK: - Variables
    
    var indexPathForProfile: IndexPath? = nil
    var promos: PromoSet = PromoSet()
    
    // MARK: - Outlet
    
    @IBOutlet weak var Promos: UITableView!
    
    // MARK: - View Loading
    
    /// What the view has to load before
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate the persons fetched and refresh the list
        self.promos.getPromos().delegate = self
    }

    /// Tell if view receive a warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Handler
    
    /// Handle delete action from a cell
    ///
    /// - Parameters:
    ///   - action: type of action
    ///   - indexPath: indexPath of the object
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) {
        let person = self.promos.getPromos().object(at: indexPath)
        CoreDataManager.context.delete(person)
    }
    
    
    // MARK: - TableView data source protocol
    
    /// Define the cell of the tableview
    ///
    /// - Parameters:
    ///   - tableView: Tableview related
    ///   - indexPath: the index of each cell
    /// - Returns: the cell with the defined values
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.Promos.dequeueReusableCell(withIdentifier: "promoCell", for: indexPath) as! PromoTableViewCell
        let promo = self.promos.getPromos().object(at: indexPath)
        cell.promo.text = "Promotion "+promo.annee!
        return cell
    }

    /// Tell the number of sections
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.promos.getPromos().sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }

    
    /// Tell if a tableview can be edited
    ///
    /// - Parameters:
    ///   - tableView: tableview related
    ///   - indexPath: index for the table
    /// - Returns: YES the table can be edited or NO
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Give different options for a selected row
    ///
    /// - Parameters:
    ///   - tableView: table view related
    ///   - indexPath: index path of the cell
    /// - Returns: type of action
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
        delete.backgroundColor = UIColor.red
        return [delete]
    }
    
    
    // MARK: - NSFetchResultController delegate protocol
    
    /// Start the update of a fetch result
    ///
    /// - Parameter controller: fetchresultcontroller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.Promos.beginUpdates()
    }
    
    /// End the update of a fetch result
    ///
    /// - Parameter controller: fetchresultcontroller
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.Promos.endUpdates()
        CoreDataManager.save()
        self.Promos.reloadData()
        self.viewDidLoad()
    }
    
    /// Control the update of the fetch result
    ///
    /// - Parameters:
    ///   - controller: fetchresultcontroller
    ///   - anObject: object type
    ///   - indexPath: indexpath of the object
    ///   - type: type of modification
    ///   - newIndexPath: if indexpath change
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .delete:
            if let indexPath = indexPath{
                self.Promos.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                self.Promos.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    
    // MARK: - Action
    
    /// Go to the registration page
    ///
    /// - Parameter sender: who send the action
    @IBAction func registrationAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.registerSegueId, sender: self)
    }
    
    /// Go to the promo add page
    ///
    /// - Parameter sender: who send the action
    @IBAction func promoAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.promoSegueId, sender: self)
    }
    
    /// Go to the add event page
    ///
    /// - Parameter sender: who send the action
    @IBAction func addEventAction(_ sender: Any) {
        performSegue(withIdentifier: self.addEventSegueId, sender: self)
    }
    
    /// Go back to the previous page
    ///
    /// - Parameter sender: who send the action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation
    
    let studentSegueId = "studentSegue"
    let registerSegueId = "registerSegue"
    let promoSegueId = "promoSegue"
    let addEventSegueId = "addEventSegue"
    
    /// prepare to send datas to the profile view ctrler
    ///
    /// - Parameters:
    ///   - segue: the related segue to the other view
    ///   - sender: who send datas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.studentSegueId{
            if let indexPath = self.Promos.indexPathForSelectedRow {
                let studentViewController = segue.destination as! StudentViewController
                studentViewController.promotion = self.promos.getPromos().object(at: indexPath)
            }
        }
    }

}
