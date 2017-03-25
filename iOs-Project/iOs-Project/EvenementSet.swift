//
//  EvenementSet.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 25/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class EvenementSet {
    
    // MARK: - Core Data constants
    
    let context = CoreDataManager.context
    let request : NSFetchRequest<Evenement> = Evenement.fetchRequest()
    
    // MARK: - Variables
    
    fileprivate lazy var eventFetched : NSFetchedResultsController<Evenement> = {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Evenement.dateDebut),ascending:false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    // MARK: - Initialization
    
    init(){
        do {
            try eventFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get events\(error)")
        }
    }
    
}

