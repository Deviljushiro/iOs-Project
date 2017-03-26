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
    
    // MARK: - Getters
    
    /// Get the event for a specific date
    ///
    /// - Parameter date: we want to find the event
    /// - Returns: the event corresponding
    class func getEventByDate(date: Date) -> [Evenement]? {
        let NSdate = date as NSDate
        let NSdate2 = date-60*60*24 as NSDate
        let NSdate3 = date+60*60*24 as NSDate
        var events: [Evenement] = []
        let request : NSFetchRequest<Evenement> = Evenement.fetchRequest()
        request.predicate = NSPredicate(format: "dateDebut >= %@ and dateDebut <= %@ and dateFin >= %@", NSdate2, NSdate3, NSdate)
        do {
            try events = CoreDataManager.context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get events by date=\(date): \(error)")
        }
        if events == [] {
            return nil
        }
        else {
            return events
        }
    }
    
    /// If a date has an event
    ///
    /// - Parameter date: we want to know if there's an event
    /// - Returns: TRUE if there's an event, else FALSE
    class func dateHasEvent(date: Date) -> Bool {
        return getEventByDate(date: date) != nil
    }
    
}

