//
//  InformationSet.swift
//  iOs-Project
//
//  Created by JeanMi on 24/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class InformationSet {
    
    // MARK: - Core Data constants
    
    let context = CoreDataManager.context
    let request : NSFetchRequest<Information> = Information.fetchRequest()
    
    // MARK: - Variables
    
    fileprivate lazy var infoFetched : NSFetchedResultsController<Information> = {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Information.dateCreation),ascending:false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    // MARK: - Initialization
    
    init(){
        do {
            try infoFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get promos\(error)")
        }
    }
    
    // MARK: - Help methods
    
    /// Re-perform the fetch
    func refresh() {
        do {
            try infoFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get promos\(error)")
        }

    }
    
    // MARK: - Getters
    
    /// Get all the infos
    ///
    /// - Returns: fetched result controller
    func getInfos() -> NSFetchedResultsController<Information>  {
        
        return infoFetched
    }
    
    /// Get infos with for specific group
    ///
    /// - Parameter group: group we want to get all the infos
    /// - Returns: return a tab of infos for the group
    func getInfosByGroup(group: Groupe) -> [Information] {
        var infos: [Information] = []
        let context = CoreDataManager.context
        let request : NSFetchRequest<Information> = Information.fetchRequest()
        request.predicate = NSPredicate(format: "concerne == %@", group)
        do {
            try infos = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get persons by lastname=\(group): \(error)")
        }
        return infos
    }

    
    
}
