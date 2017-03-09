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
    @IBOutlet weak var MessageField: UITextField!
    @IBOutlet weak var SideView: UIView!
    @IBOutlet weak var Messages: UITableView!

    // MARK: - Variables
    
    var person : Personne? = nil
    var listMsg : MessagesSet = MessagesSet()
    var sentImage : UIImage? = nil
    
    
    /// The list of messages fetched for the view
    fileprivate lazy var msgFetched : NSFetchedResultsController<Message> = {
        //prepare request
        let request : NSFetchRequest<Message> = Message.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.dateEnvoi),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    // MARK: - Constants
    
    let picker = UIImagePickerController()
    
    // MARK: - Table loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate the picker
        picker.delegate = self
        //fetch all the messages
        do {
            try self.msgFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
        //start with the last messages
        self.Messages.scrollToRow(at: self.getLastIndexPath(), at: .bottom, animated: false)
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
        let msg = self.msgFetched.object(at: indexPath)
        cell.sendDate.text = msg.dateEnvoi
        cell.body?.text = msg.contenu
        cell.sender.text = msg.ecritPar?.pseudo
        cell.senderPic.image = UIImage(data: self.person?.photo as! Data)
        if let image = msg.image {  //the image isn't empty
            cell.msgImage?.image = UIImage(data: image as! Data)
        }
        else {  //or it's empty
            cell.msgImage?.image = #imageLiteral(resourceName: "blank")
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
        guard let section = self.msgFetched.sections?[section] else {
            fatalError("unexpected section number")
        }
        return section.numberOfObjects
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
        CoreDataManager.save()
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
            self.saveNewMessage(withBody: "", withImage: imageData)
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
    
    
    /// Create a new msg and save it in the set
    ///
    /// - Parameters:
    ///   - id: of the msg
    ///   - body: of the msg
    ///   - sendDate: of the msg
    ///   - image: of the msg
    func saveNewMessage(withBody body: String,withImage image: NSData?){
        let msg = Message.createNewMessage(body: body,image: image, person: self.person!)
        if let error = CoreDataManager.save() {
            DialogBoxHelper.alert(view: self, error: error)
        }
        else {
            self.listMsg.addMessage(message: msg, personne: self.person!)
        }
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
        guard let body = MessageField?.text else {
            DialogBoxHelper.alert(view: self, WithTitle: "Echec envoi", andMsg: "Message vide")
            return
        }
        self.saveNewMessage(withBody: body, withImage: nil)
        //refresh the page
        self.viewDidLoad()
    }
    
    
    /// Log out the user
    ///
    /// - Parameter sender: who send the action
    @IBAction func logoutAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            profileViewController.person = self.person
        }
    }
    

}
