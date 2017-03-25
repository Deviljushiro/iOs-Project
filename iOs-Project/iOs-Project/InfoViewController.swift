//
//  InfoViewController.swift
//  iOs-Project
//
//  Created by JeanMi on 24/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var Infos: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: - Variables
    
    var group: Groupe? = nil    //the group of the info page
    var infos: InformationSet = InformationSet()
    
    //MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.infos.getInfos().delegate = self
        self.infos.refresh()
        
        //Enable the admin to click on add button
        if Session.getSession().isAdmin(){
            self.addButton.isEnabled = true
            self.addButton.isHidden = false
        }
        else{
            self.addButton.isEnabled = false
            self.addButton.isHidden = true
        }

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
        let cell = self.Infos.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
        let info = self.infos.getInfos().object(at: indexPath)
        cell.title.text = info.titre
        cell.body.text = info.desc
        cell.url.text = info.lien
        cell.sentDate.text = info.dateCreation
        cell.pic.image = UIImage(data: info.image as! Data)
        return cell
    }
    
    /// Tell the number of sections
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let section = self.infos.getInfos().sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
    }
    
    
    // MARK: - NSFetchResultController delegate protocol
    
    /// Start the update of a fetch result
    ///
    /// - Parameter controller: fetchresultcontroller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.Infos.beginUpdates()
    }
    
    /// End the update of a fetch result
    ///
    /// - Parameter controller: fetchresultcontroller
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.Infos.endUpdates()
        CoreDataManager.save()
        self.Infos.reloadData()
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
                self.Infos.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                self.Infos.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }


    
    //MARK: - Actions
    
    /// Go back to the previous page
    ///
    /// - Parameter sender: who send the action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Go to the add info page
    ///
    /// - Parameter sender: who send the action
    @IBAction func addAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addInfoSegue", sender: self)
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
