//
//  GroupMessageViewController.swift
//  iOs-Project
//
//  Created by Jean Miquel on 23/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class GroupMessageViewController: KeyboardViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var MessageField: UITextView!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var ListMessages: UITableView!
    
    // MARK: - Variables
    
    var group : Groupe? = nil
    var msgFetched : MessagesSet = MessagesSet()
    var sentImage : UIImage? = nil  //To send image via message
    var selectedPerson: Personne? = nil //To see sender's profile
    
    //MARK: - Constants
    
    let picker = UIImagePickerController()

    //MARK: - View loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the group and change the fetched result of the messages
        if let agroup = self.group {
            self.msgFetched = MessagesSet(group: agroup)
        }
        
        //delegate the picker and messages fetched
        self.msgFetched.getMessages().delegate = self
        picker.delegate = self
        self.msgFetched.refreshMsg()
        
        //start with the last messages
        if (msgFetched.getNumberMessages()>0) {
            self.ListMessages.scrollToRow(at: self.getLastIndexPath(), at: .bottom, animated: false)
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
        //get the msg datas from the fetched msg
        let msg = self.msgFetched.getMessages().object(at: indexPath)
        let cell = self.ListMessages.dequeueReusableCell(withIdentifier: "messageCell2", for: indexPath) as! MessageTableViewCell
        //get the msg datas from the fetched msg
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
        return cell
    }
    
    /// Tell the number of sections
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
    
    /// if the keyboard has to disappear after Return
    ///
    /// - Parameter textView: related textView
    /// - Returns: TRUE it has to go out, FALSE else
    func textViewShouldReturn(_ textView: UITextView) -> Bool{
        textView.resignFirstResponder()
        return true
    }
    
    /// Before editing the textView
    ///
    /// - Parameter textView: the text view
    func textViewDidBeginEditing(_ textView: UITextView){
        MessageField = textView
    }
    
    /// After edition of the text view
    ///
    /// - Parameter textView: related text view
    func textViewDidEndEditing(_ textView: UITextView){
        MessageField = nil
    }
    
    // MARK: - Keyboard overriding
    
    /// Size the keyboard and scroll the page according to this message page
    ///
    /// - Parameter notification: notif which called the method
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // MARK: - NSFetchResultController delegate protocol
    
    /// Start the update of a fetch result
    ///
    /// - Parameter controller: fetchresultcontroller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.ListMessages.beginUpdates()
    }
    
    /// End the update of a fetch result
    ///
    /// - Parameter controller: fetchresultcontroller
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.ListMessages.endUpdates()
        self.ListMessages.reloadData()
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
                self.ListMessages.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                self.ListMessages.insertRows(at: [newIndexPath], with: .fade)
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
            Message.createNewMessage(body: "", image: imageData, person: Session.getSession(),group:self.group)
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
        let lastSectionIndex = self.ListMessages.numberOfSections - 1
        // Then grab the number of rows in the last section
        let lastRowIndex = self.ListMessages.numberOfRows(inSection: lastSectionIndex) - 1
        // Now just construct the index path
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        return pathToLastRow
    }
    
    
    // MARK: - Actions
    
    /// Go back to the previous page
    ///
    /// - Parameter sender: who send the action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// send the message by clicking "Envoyer" button
    ///
    /// - Parameter sender: wh osend the action

    @IBAction func sendMessage(_ sender: Any) {
        guard let body = MessageField?.text else {
            DialogBoxHelper.alert(view: self, WithTitle: "Echec envoi", andMsg: "Message vide")
            return
        }
        Message.createNewMessage(body: body, image: nil, person: Session.getSession(),group: self.group)
        //refresh the page
        self.viewDidLoad()
    }


    /// Allow the user to send a picture by clicking the file button
    ///
    /// - Parameter sender: who send the action
    @IBAction func addImage(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)

    }
    
    /// Go to the information page
    ///
    /// - Parameter sender: who send the action
    @IBAction func infoAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.infoSegueId, sender: self)
    }
    
    /// Go the to profile of the sender
    ///
    /// - Parameter sender: who send the action
    @IBAction func personProfileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.personProfileSegueId, sender: self)
    }

    /// Go to the admin page
    ///
    /// - Parameter sender: who send the action
    @IBAction func adminAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.adminSegueId, sender: self)
    }
    
    /// Go to the session profile page
    ///
    /// - Parameter sender: who send the action
    @IBAction func myProfileAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.myProfileSegueId, sender: self)
    }
    

    // MARK: - Navigation
    
    let adminSegueId = "adminSegue"
    let personProfileSegueId = "personProfileSegue"
    let myProfileSegueId = "myProfileSegue"
    let infoSegueId = "infoSegue"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.myProfileSegueId {
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
