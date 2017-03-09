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
    
    // MARK: - Constants
    
    let picker = UIImagePickerController()
    
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
    
    // MARK: - Table loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
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
        cell.content.text=self.listMsg.listMsg[indexPath.row].contenu
        cell.date.text=self.listMsg.listMsg[indexPath.row].dateEnvoi
        return cell
    }
    
    /// Tell the number of sections
    ///
    /// - Parameters:
    ///   - tableView: Table view related
    ///   - section: number of lines for each section
    /// - Returns: number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.listMsg.numbersOfMessages
    }
    
    
    
    //MARK: - Image delegates
    
    /// Pick the image
    ///
    /// - Parameters:
    ///   - picker: picker which has to pick image
    ///   - info: about finish picking media
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.sentImage = chosenImage
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
        let msg = Message.createNewMessage(body: body,image: image)
        if let error = CoreDataManager.save() {
            DialogBoxHelper.alert(view: self, error: error)
        }
        else {
            self.listMsg.addMessage(message: msg, personne: self.person!)
        }
    }
    

    
    // MARK: - Actions
    
    
    /// send the message by clicking "Envoyer" button
    ///
    /// - Parameter sender: wh osend the action
    @IBAction func sendMessage(_ sender: Any) {
        let body = MessageField.text ?? ""
        var imageData: NSData? = nil
        if let image = sentImage {  //the image isn't empty
            imageData = UIImageJPEGRepresentation(image, 1)! as NSData
        }
        self.saveNewMessage(withBody: body, withImage: imageData)
        Messages.reloadData()
        //guard let mes = MessageField.text, mes != "" else {
        // DialogBoxHelper.alert(view: self, WithTitle: "Envoi message impossible", andMsg: "message vide")
        //  return
        //}
        //saveNewMessage(message: mes)
    }
    
    
    /// Log out the user
    ///
    /// - Parameter sender: who send the action
    @IBAction func logoutAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Add an image to a message by clicking the grey icon
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
