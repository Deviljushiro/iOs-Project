//
//  ListViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    // MARK: - Variables
    
    var listPersons = PersonnesSet()
    var indexPathForProfile: IndexPath? = nil
    

    // MARK: - Outlet
    
    @IBOutlet weak var Personnes: UITableView!
    
    // MARK: - View Loading
    
    /// What the view has to load before
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Tell if view receive a warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Person data management
    
    /// create a new person and save it
    ///
    /// - Parameters:
    ///     - nom: lastname of the person
    ///     - prenom: firstname of the person
    func saveNewPerson(withLastName nom: String, andFirstname prenom: String, andTel tel: String, andCity ville: String, andPwd mdp: String, andImage image: NSData){
        let person = Personne.createNewPersonne(firstName: prenom, name: nom, tel: tel, city: ville, pwd: mdp, image: image)
        if let error = CoreDataManager.save() {
            DialogBoxHelper.alert(view: self, error: error)
        }
        else {
            self.listPersons.addPerson(person: person)
        }
    }
    
    /// delete a person
    ///
    /// - Parameter index: index of the related person
    /// - Returns: TRUE if deleted, FALSE else
    func delete(personWithIndex index: Int) ->Bool {
        //get the context
        let context = CoreDataManager.getContext()
        let person = self.listPersons.getPersonAtIndex(withIndex: index)
        context.delete(person)
        // try to save it
        if let error = CoreDataManager.save() {
            DialogBoxHelper.alert(view: self, error: error)
            return false
        }
        else {
                self.listPersons.deletePerson(atIndex: index)
                return true
        }
    }
    
    
    // MARK: - TableView data source protocol
    
    /// Define the cell of the tableview
    ///
    /// - Parameters:
    ///   - tableView: Tableview related
    ///   - indexPath: the index of each cell
    /// - Returns: the cell with the defined values
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.Personnes.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! ListTableViewCell
        cell.nom.text = self.listPersons.getPersonAtIndex(withIndex: indexPath.row).nom
        cell.prenom.text = self.listPersons.getPersonAtIndex(withIndex: indexPath.row).prenom
        return cell
    }

    /// Tell the number of sections
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.listPersons.getAllPersons().count
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
    

    /// Edit a tableview
    ///
    /// - Parameters:
    ///   - tableView: tableview related
    ///   - editingStyle: what type of edition
    ///   - indexPath: index of each cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //manage deleting
        if (editingStyle==UITableViewCellEditingStyle.delete){
            self.Personnes.beginUpdates()
            if self.delete(personWithIndex: indexPath.row){
                self.Personnes.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            self.Personnes.endUpdates()
        }
    }

    
    // MARK: - Action
    
    
    /// Go to the Add page
    ///
    /// - Parameter sender: who send action
    @IBAction func addAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.addSegueId, sender: self)
    }
    
    
    /// When datas need to be obtained from the previous page
    ///
    /// - Parameter segue: The segue related to the previous page
    @IBAction func unwindToPersonsListAfterSaving(segue: UIStoryboardSegue){
        CoreDataManager.save()
        self.Personnes.reloadData()
        }


    // MARK: - Navigation
    
    let profileSegueId = "profileSegue"
    let addSegueId = "addSegue"
    
    /// prepare to send datas to the profile view ctrler
    ///
    /// - Parameters:
    ///   - segue: the related segue to the other view
    ///   - sender: who send datas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.profileSegueId{
            if let indexPath = self.Personnes.indexPathForSelectedRow {
                let profileViewController = segue.destination as! ProfileViewController
                profileViewController.person = self.listPersons.getPersonAtIndex(withIndex: indexPath.row)
                self.Personnes.deselectRow(at: indexPath, animated: true)
            }
        }
    }

}
