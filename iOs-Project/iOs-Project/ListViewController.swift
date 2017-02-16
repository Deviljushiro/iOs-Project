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
    
    var listePersonnes: [Personne] = []
    

    // MARK: - Outlet
    
    @IBOutlet weak var Personnes: UITableView!
    
    // MARK: - View Loading
    
    /// What the view has to load before be printed
    override func viewDidLoad() {
        super.viewDidLoad()
        //get the context
        guard let context = self.getContext(errorMsg: "Person not found") else { return }
        //create query related to the Personne entity
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        do {
            try self.listePersonnes = context.fetch(request)
        }
        catch let error as NSError{
            self.alertError(WithTitle: "\(error)", andMsg: "\(error.userInfo)")
            return
        }
    }

    /// Tell if viex receive a warning
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
    func saveNewPerson(withLastName nom: String, andFirstname prenom: String, andTel tel: String, andCity ville: String){
        //get the context
        guard let context = self.getContext(errorMsg: "Save failed")
            else {
                return
        }
        //create a person
        let person = Personne(context: context)
        //modify profile
        person.nom = nom
        person.prenom = prenom
        person.pseudo = prenom+"."+nom
        person.tel = tel
        person.ville = ville
        do{
            try context.save()
            self.listePersonnes.append(person)
        }
        catch let error as NSError{
                self.alert(error: error)
                return
        }
    }
    
    /// delete a person
    ///
    /// - Parameter index: index of the related person
    /// - Returns: TRUE if deleted, FALSE else
    func delete(personWithIndex index: Int) ->Bool {
        guard let context = self.getContext(errorMsg: "Couldn't delete")
            else { return false }
        let person = self.listePersonnes[index]
        context.delete(person)
        do {
            try context.save()
            self.listePersonnes.remove(at: index)
            return true
        }
        catch let error as NSError {
            self.alert(error: error)
            return false
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
        cell.nom.text = self.listePersonnes[indexPath.row].nom
        cell.prenom.text = self.listePersonnes[indexPath.row].prenom
        return cell
    }

    /// Tell the number of sections
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.listePersonnes.count
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

    
    // MARK: - Button
    
    
    /// Go to the Add page
    ///
    /// - Parameter sender: the object itself
    @IBAction func addAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addSegue", sender: self)
    }

    
    /// When datas need to be obtained from the previous page
    ///
    /// - Parameter segue: The segue related to the previous page
    @IBAction func unwindToPersonsListAfterSaving(segue: UIStoryboardSegue){
        print("I'm back")
        let addController = segue.source as! AddViewController
        let firstname = addController.prenomLabel.text ?? ""
        let lastname = addController.nomLabel.text ?? ""
        let tel = addController.telLabel.text ?? ""
        let city = addController.villeLabel.text ?? ""
        self.saveNewPerson(withLastName: lastname, andFirstname: firstname, andTel: tel, andCity: city)
        self.Personnes.reloadData()
        }


    // MARK: - Navigation
    
    let profileSegueId = "profileSegue"
    
    
    /// prepare to send datas to the profile view ctrler
    ///
    /// - Parameters:
    ///   - segue: the related segue to the other view
    ///   - sender: who send datas
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.profileSegueId{
            if let indexPath = self.Personnes.indexPathForSelectedRow{
                let profileViewController = segue.destination as! ProfileViewController
                profileViewController.person = self.listePersonnes[indexPath.row]
                self.Personnes.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // MARK: - Helper methods
    
    ///get context of core data
    ///
    /// - Parameters: 
    ///     - errorMsg: main error msg
    ///     - userInfoMsg: additional info user want to display
    /// - Returns: context of the core data
    func getContext(errorMsg: String, userInfoMsg: String = "could not retrieve data context") -> NSManagedObjectContext? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            //assertionFailure("No Application Delegate!")
            self.alertError(WithTitle: errorMsg, andMsg: userInfoMsg)
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Alerts
    
    /// When need to send an alert with the alert methode
    ///
    /// - Parameters:
    ///   - error: error title
    ///   - user: message from the user
    func alertError(WithTitle error: String, andMsg user: String = "") {
        let alert = UIAlertController(title: error, message: user, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    /// When an error is caught
    ///
    /// - Parameter error: NSError caught
    func alert(error: NSError) {
        self.alertError(WithTitle: "\(error)", andMsg: "\(error.userInfo)")
    }

}
