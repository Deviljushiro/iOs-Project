//
//  MessagesSet.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 06/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MessagesSet {
    
    // MARK: - CoreData Constant
    
    let context = CoreDataManager.context
    let request : NSFetchRequest<Message> = Message.fetchRequest()
    
    
    // MARK: - Variables
    
    var currentGroupName = "All"
    
    //DEFAULT : Get the messages of the global group where there's everybody
    fileprivate lazy var msgFetched : NSFetchedResultsController<Message> = {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.dateEnvoi),ascending:true)]
        self.request.predicate = NSPredicate(format: "concerner.name == %@",self.currentGroupName)
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController}()
    
    // MARK : - Initialization
    
    /// Initialize the messages by fetching all msg in the DB
    init(){
        do {
            try msgFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get messages\(error)")
        }
    }

    /// Initialize the messages by fetching according to a group
    ///
    /// - Parameter group: messages's group
    init(group: Groupe){
        self.currentGroupName=group.name!
        do {
            try msgFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get messages\(error)")
        }
    }
    
    /// Initialize the messages with a selection from a keyword according to a specific group
    ///
    /// - Parameter group: messages's group
    init(string: String, group: Groupe){
        self.currentGroupName=group.name!
        self.msgFetched = self.valueForMessageFetched(string: string)
        do {
            try msgFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get messages\(error)")
        }
    }
    
    // MARK: - Help methods
    
    /// Re-perform the fetch for the NSFetchResult
    func refreshMsg(){
        do {
            try msgFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get messages\(error)")
        }

    }
    
    /// Change the request of the fetch result according to  a keyword
    ///
    /// - Parameter string: keyword
    /// - Returns: the new fetch result controller
    func valueForMessageFetched(string: String) -> NSFetchedResultsController<Message> {
        //Search even with lower cased or upper cased
        let stringLow = string.lowercased()
        let stringUp = string.uppercased()
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.dateEnvoi),ascending:true)]
        request.predicate = NSPredicate(format: "(contenu CONTAINS %@ or contenu CONTAINS %@ or contenu CONTAINS %@) and concerner.name == %@", string, stringLow, stringUp ,self.currentGroupName)
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    


    // MARK: - Getters
    
    /// Get all the messages
    ///
    /// - Returns: msgFetched
    func getMessages() -> NSFetchedResultsController<Message>  {
        return msgFetched
    }

    /// Get the number of msg in the DB
    ///
    /// - Returns: number of msg (int)
    func getNumberMessages() -> Int {
        return (msgFetched.fetchedObjects!.count)
    }
    
    /// Get the number of message in a set (for the autoincrement in Message)
    ///
    /// - Returns: how many messages are in the set
    static func getNumbersOfMessages()-> Int{
        var msgs: [Message] = []
        let context = CoreDataManager.context
        let request : NSFetchRequest<Message> = Message.fetchRequest()
        do {
            try msgs = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get number of messages\(error)")
        }
        return msgs.count
    }
    
}
