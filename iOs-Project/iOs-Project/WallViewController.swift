//
//  WallViewController.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 22/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit
import CoreData

class WallViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var ListMessages: UITableView!
    @IBOutlet weak var MessageField: UITextView!
    @IBOutlet weak var SideView: UIView!
    @IBOutlet weak var Messages: UITableView!
    @IBOutlet weak var adminButton: UIButton!

    // MARK: - Variables
    
    var msgFetched : MessagesSet = MessagesSet()
    var sentImage : UIImage? = nil
    
    // MARK: - Constants
    
    let picker = UIImagePickerController()
    
    // MARK: - Table loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate the picker and messages fetched
        self.msgFetched.getMessages().delegate = self
        picker.delegate = self
        self.msgFetched.refreshMsg()
        
        //start with the last messages
        if (msgFetched.getNumberMessages()>0) {
          self.Messages.scrollToRow(at: self.getLastIndexPath(), at: .bottom, animated: false)
        }
        
        //Notifications to manage the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        let cell = self.Messages.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        //get the msg datas from the fetched msg
        let msg = self.msgFetched.getMessages().object(at: indexPath)
        cell.sendDate.text = msg.dateEnvoi
        cell.body?.text = msg.contenu
        cell.sender.text = msg.ecritPar?.pseudo
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
    
    // MARK : - Keyboard
    
    /// Size the keyboard and scroll the page according to it
    ///
    /// - Parameter notification: notif which called the method
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (self.MessageField?.frame.origin.y)! >= keyboardSize.height {
                self.view.frame.origin.y = keyboardSize.height - (self.MessageField?.frame.origin.y)!
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    /// Keyboard disappear
    ///
    /// - Parameter notification: notif which called the method
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
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
            Message.createNewMessage(body: "", image: imageData, person: Session.getSession())
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

    
    
    // MARK: - Message data management
    
    

    
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
        guard let body = MessageField?.text else {
            DialogBoxHelper.alert(view: self, WithTitle: "Echec envoi", andMsg: "Message vide")
            return
        }
        Message.createNewMessage(body: body, image: nil, person: Session.getSession())
        //refresh the page
        self.viewDidLoad()
    }
    
    
    /// Log out the user by destroying the Session
    ///
    /// - Parameter sender: who send the action
    @IBAction func logoutAction(_ sender: Any) {
        Session.destroySession()
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    
    /// Go to the admin page
    ///
    /// - Parameter sender: who send the action
    @IBAction func adminAction(_ sender: Any) {
        self.performSegue(withIdentifier: "adminSegue", sender: self)
    }
    
    
    /// Go to the profile page
    ///
    /// - Parameter sender: who send the action
    @IBAction func myProfileAction(_ sender: Any) {
        self.performSegue(withIdentifier: profileSegueId, sender: self)
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
    
    let profileSegueId = "myProfileSegue"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.profileSegueId {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.person = Session.getSession()
        }
    }
    

}
