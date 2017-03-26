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

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var Infos: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Variables
    
    var group: Groupe? = nil    //the group of the info page
    var infos: InformationSet = InformationSet()
    var chosenScope: String = "Tous"  //the selected scope of the search bar
    
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
        
        //Get the profile pic and make it circle
        self.profilePic.image = UIImage(data: Session.getSession().photo as! Data)
        self.profilePic.maskCircle(anyImage: self.profilePic.image!)
        
        //delegate the search bar
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Search bar protocol
    
    /// When text is input in the search bar
    ///
    /// - Parameters:
    ///   - searchBar: where text is input
    ///   - searchText: the text input
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if self.chosenScope == "Tous" {  //If the scope is about all keywords
            if searchText == "" {   //If the input text is empty
                self.infos = InformationSet()
            }
            else {  //If not
                self.infos = InformationSet(title: searchText)
            }
        }
        else {  //If there's a specific scope selected
            if searchText == "" {   //If the input text is empty
                self.infos = InformationSet(keyword: self.chosenScope)
            }
            else {  //If not
                self.infos = InformationSet(keyword: self.chosenScope, title: searchText)
            }
        }
        self.Infos.reloadData()
        self.viewDidLoad()
    }
    
    
    /// When a scope is clicked
    ///
    /// - Parameters:
    ///   - searchBar: where the scope is activated
    ///   - selectedScope: the selected scope
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //Get the chosen scope from the array of scope titles
        let scopeTitles: [String] = ["Tous","Documents","Medias","Administration","Divers"]
        self.chosenScope = scopeTitles[selectedScope]
        //If there's a specific keyword
        if self.chosenScope != "Tous" {
            if self.searchBar.text == "" {  //If the search bar is empty
                self.infos = InformationSet(keyword: self.chosenScope)
            }
            else {
                self.infos = InformationSet(keyword: self.chosenScope, title: self.searchBar.text!)
            }
        }
        else { //if not
            if self.searchBar.text == "" {  //If the search bar is empty
                self.infos = InformationSet()
            }
            else {
                self.infos = InformationSet(title: self.searchBar.text!)
            }
        }
        self.Infos.reloadData()
        self.viewDidLoad()

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
        self.performSegue(withIdentifier: self.addInfoSegueId, sender: self)
    }
    
    /// Go to the session profile page
    ///
    /// - Parameter sender: who send the action
    @IBAction func myProfileAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.myProfileSegueId, sender: self)
    }
    
    
    // MARK: - Navigation
    
    let addInfoSegueId = "addInfoSegue"
    let myProfileSegueId = "myProfileSegue"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.myProfileSegueId {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.person = Session.getSession()
        }

    }
    

}
