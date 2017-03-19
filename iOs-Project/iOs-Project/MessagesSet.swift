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
    
    let context = CoreDataManager.getContext()
    let request : NSFetchRequest<Message> = Message.fetchRequest()
    
    // MARK: - Variables
    
    fileprivate lazy var msgFetched : NSFetchedResultsController<Message> = {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.dateEnvoi),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: CoreDataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil)
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
        msgFetched = valueForMsgFetched(group: group)
        do {
            try msgFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get messages\(error)")
        }
    }
    
    /// Re-perform the fetch for the NSFetchResult
    func refreshMsg(){
        do {
            try msgFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get messages\(error)")
        }

    }
    
    /// Give a fetchResultController value to msfFetched according to a group
    ///
    /// - Parameter group: group we want to get the messages
    /// - Returns: NSFetchResultController of the group's message
    func valueForMsgFetched(group: Groupe) -> NSFetchedResultsController<Message> {
            request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Message.dateEnvoi),ascending:true)]
            request.predicate = NSPredicate(format: "concerner == %@", group)
            let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: CoreDataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil)
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
    
}
