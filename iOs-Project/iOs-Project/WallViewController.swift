//
//  WallViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 22/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class WallViewController: KeyboardViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITextViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var MessageField: UITextView!
    @IBOutlet weak var SideView: UIView!
    @IBOutlet weak var Messages: UITableView!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Variables
    
    var msgFetched : MessagesSet = MessagesSet()
    var sentImage : UIImage? = nil  //To send image via message
    var selectedPerson: Personne? = nil //To see sender's profile
    var isFieldActivated: Bool = false  //if the user is typing a msg for the keyboard protocol

    
    // MARK: - Constants
    
    let picker = UIImagePickerController()
    
    // MARK: - Table loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegations
        self.msgFetched.getMessages().delegate = self
        self.picker.delegate = self
        self.searchBar.delegate = self
        self.MessageField.delegate = self
        
        self.msgFetched.refreshMsg()
        
        //start with the last messages
        if (msgFetched.getNumberMessages()>0) {
          self.Messages.scrollToRow(at: self.getLastIndexPath(), at: .bottom, animated: false)
        }
        
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
    
    
    // MARK: - Search bar protocol
    
    /// When text is input in the search bar
    ///
    /// - Parameters:
    ///   - searchBar: where text is input
    ///   - searchText: the text input
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {   //If the input text is empty
            self.msgFetched = MessagesSet()
        }
        else {  //If not
            let groupAll = GroupesSet.getGroupByName(groupName: "All")
            self.msgFetched = MessagesSet(string: searchText, group: groupAll!)
        }
        self.Messages.reloadData()
        self.viewDidLoad()
    }
    
    
    // MARK: - Table view datasource protocol
    
    /// Define the cell of the tableview
    ///
    /// - Parameters:
    ///   - tableView: Tableview related
    ///   - indexPath: the index of each cell
    /// - Returns: the cell with the defined values
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //create the cell
        let cell = self.Messages.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        //get the msg datas from the fetched msg
        let msg = self.msgFetched.getMessages().object(at: indexPath)
        cell.sendDate.text = msg.dateEnvoi
        cell.body?.text = msg.contenu
        cell.username.setTitle(msg.ecritPar?.pseudo, for: .normal)
        cell.senderPic.image = UIImage(data: msg.ecritPar!.photo as! Data)
        if let bimage = msg.image {  //the image isn't empty
            if let image = UIImage(data: bimage as Data){
                cell.msgImage.sizeThatFits(image.size)
                cell.msgImage.image = image
            }
            else{
                cell.msgImage.image = nil
            }
        }
        else {  //or it's empty
            cell.msgImage.image = nil
        }
        cell.senderPic.maskCircle(anyImage: cell.senderPic.image!) //Circle image
        return cell
    }
    
    /// Tell the number of sections (for a search or not)
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            guard let section = self.msgFetched.getMessages().sections?[section] else {
                fatalError("unexpected section number")
            }
        return section.numberOfObjects
    }
    
    // MARK: - Text view protocol

    
    /// Tells the controller that editing has begun
    ///
    /// - Parameter textView: the related textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isFieldActivated = true
    }
    
    /// Tells the controller that editing is finished
    ///
    /// - Parameter textView: the related textView
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isFieldActivated = false
    }
    

    // MARK: - Keyboard overriding
    
    /// Size the keyboard if the user is writing message only
    ///
    /// - Parameter notification: notif which called the method
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        
            if self.view.frame.origin.y == 0 {
                if self.isFieldActivated {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }


    // MARK: - NSFetchResultController delegate protocol
    
    /// Start the update of a fetch result
    ///
    /// - Parameter controller: fetchresultcontroller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.Messages.beginUpdates()
    }
    
    /// End the update of a fetch result
    ///
    /// - Parameter controller: fetchresultcontroller
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.Messages.endUpdates()
        self.Messages.reloadData()
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
                self.Messages.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.Messages.insertRows(at: [newIndexPath], with: .fade)
            }
        default:
            break
        }
    }
    
    
    //MARK: - Image delegates
    
    /// Pick the image and send it
    ///
    /// - Parameters:
    ///   - picker: picker which has to pick image
    ///   - info: about finish picking media
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.sentImage = chosenImage
            let image = sentImage
            let imageData = UIImageJPEGRepresentation(image!, 1)! as NSData
            Message.createNewMessage(body: "", image: imageData, person: Session.getSession(), group: GroupesSet.getGroupByName(groupName: "All"))
            //refresh the page
            self.viewDidLoad()
            dismiss(animated:true, completion: nil)
        }
    }
    
    /// When clicking cancel, remove the picker
    ///
    /// - Parameter picker: The picker which has to be removed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Index tools
    
    /// get the last index path of the table view
    ///
    /// - Returns: index path
    func getLastIndexPath() -> IndexPath{
        // First figure out how many sections there are
        let lastSectionIndex = self.Messages.numberOfSections - 1
        // Then grab the number of rows in the last section
        let lastRowIndex = self.Messages.numberOfRows(inSection: lastSectionIndex) - 1
        // Now just construct the index path
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        return pathToLastRow
    }

    
    // MARK: - Actions
    
    
    /// send the message by clicking "Envoyer" button
    ///
    /// - Parameter sender: wh osend the action
    @IBAction func sendMessage(_ sender: Any) {
        guard let body = MessageField?.text, body != "" else {
            DialogBoxHelper.alert(view: self, WithTitle: "Echec envoi", andMsg: "Message vide")
            return
        }
        Message.createNewMessage(body: body, image: nil, person: Session.getSession(), group: GroupesSet.getGroupByName(groupName: "All"))
        self.MessageField.text = "" //Clear the field
        //refresh the page
        self.viewDidLoad()
    }
    
    
    /// Log out the user by destroying the Session
    ///
    /// - Parameter sender: who send the action
    @IBAction func logoutAction(_ sender: Any) {
        Session.destroySession()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Go to the admin page
    ///
    /// - Parameter sender: who send the action
    @IBAction func adminAction(_ sender: Any) {
        self.performSegue(withIdentifier: "adminSegue", sender: self)
    }
    
    
    /// Go to the infos page
    ///
    /// - Parameter sender: who send the action
    @IBAction func infoAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.infoSegueId, sender: self)
    }
    
    
    /// Go to the profile page
    ///
    /// - Parameter sender: who send the action
    @IBAction func myProfileAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.profileSegueId, sender: self)
    }

    /// Go to the groupList page
    ///
    /// - Parameter sender: who send the action
    @IBAction func myGroupsAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.groupListSegueId, sender: self)
    }
    
    /// Go to the profile of the sender
    ///
    /// - Parameter sender: who send the action
    @IBAction func personProfileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.personProfileSegueId, sender: sender)
    }
    
    /// Send an image
    ///
    /// - Parameter sender: who send the action
    @IBAction func addImage(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    let infoSegueId = "infoSegue"
    let profileSegueId = "myProfileSegue"
    let groupListSegueId = "groupListSegue"
    let personProfileSegueId = "personProfileSegue"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.profileSegueId {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.person = Session.getSession()
        }
            //by clicking on a username
        if segue.identifier == self.personProfileSegueId {
            //Get the selected person by the sender UIButton
            self.selectedPerson = PersonnesSet.getPersonsByUsername(withUsername: ((sender as AnyObject).titleLabel??.text)!)
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.person = self.selectedPerson
        }

    }
}

