//
//  Personne.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 22/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Personne {
    
    /// Get a person with a specific id
    ///
    /// - Parameter withId: username of the person
    /// - Returns: return a tab of persons
    class func getPersonsById(withId: String) -> [Personne] {
        var persons: [Personne] = []
        let context = CoreDataManager.getContext()
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        request.predicate = NSPredicate(format: "pseudo == %@", withId)
        do {
            try persons = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get persons by pseudo=\(withId): \(error)")
        }
        return persons
    }
    
    /// Get all the persons is the DB
    ///
    /// - Returns: array of persons
    class func getAllPersons() -> [Personne] {
        var persons: [Personne] = []
        let context = CoreDataManager.getContext()
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        do {
            try persons = context.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        return persons
    }
    
    
}
