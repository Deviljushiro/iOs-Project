//
//  GroupesSet.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 22/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class GroupesSet{
    
    // MARK: - CoreData Constant
    
    let context = CoreDataManager.getContext()
    let request : NSFetchRequest<Groupe> = Groupe.fetchRequest()

    // MARK: - Variables
    
    
    
    fileprivate lazy var groupFetched : NSFetchedResultsController<Groupe> = {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Groupe.name),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: CoreDataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    // MARK: - Initialization
    
    /// Initialize the messages by fetching all msg in the DB
    init(person: Personne){
        groupFetched = valueForGroupFetched(person: person)
        do {
            try groupFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get messages\(error)")
        }
    }
    
    // MARK: - Help methods
    
    /// Give a fetchResultController value to personFetched according to a promo
    ///
    /// - Parameter promo: group we want to get the students
    /// - Returns: NSFetchResultController of the promo's students
    func valueForGroupFetched(person: Personne) -> NSFetchedResultsController<Groupe> {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Groupe.name),ascending:true)]
        self.request.predicate = NSPredicate(format: "concerner CONTAINS %@ and name != 'All'", person)
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: CoreDataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }

    
    // MARK: - Getters

    /// Get groups with a specific name
    ///
    /// - Parameter groupName: name of the group
    /// - Returns: return the first index of tab of persons with the username
    class func getGroupByName(groupName gn: String) -> Groupe? {
        var groups: [Groupe] = []
        let request : NSFetchRequest<Groupe> = Groupe.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", gn)
        do {
            try groups = CoreDataManager.context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get the group with the name=\(gn): \(error)")
        }
        if groups==[] {
            return nil
        }
        else {
            return groups[0]
        }
    }
    
    
    /// return true if there is groups in the database
    ///
    /// - Returns: return true if there is groups in the database
    static func getNumbersOfGroups()-> Int{
        var groups: [Groupe] = []
        let context = CoreDataManager.getContext()
        let request : NSFetchRequest<Groupe> = Groupe.fetchRequest()
        do {
            try groups = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get number of messages\(error)")
        }
        return groups.count
    }
    
    /// Get all the groups
    ///
    /// - Returns: msgFetched
    func getGroups() -> NSFetchedResultsController<Groupe>  {
        return groupFetched 
    }

}
