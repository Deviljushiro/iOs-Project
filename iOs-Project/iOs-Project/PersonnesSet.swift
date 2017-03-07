//
//  PersonnesSet.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 02/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PersonnesSet {
    
    let context = CoreDataManager.getContext()
    let request : NSFetchRequest<Personne> = Personne.fetchRequest()
    
    var listPersons : [Personne]
    
    // MARK : - Initialization
    
    init(){
        do {
            try self.listPersons = self.context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get number of messages\(error)")
        }
    }
    
    // MARK: - Data Manager
    
    /// Add a person to the set
    ///
    /// - Parameters:
    ///   - person: the person we want to add
    /// - Returns: the person we added (or nil if the save failed)
    func addPerson(person p:Personne) {
        self.listPersons.append(p)
    }
    
    /// Delete a person from the set with a specific index
    ///
    /// - Parameters:
    ///   - index: the person's index where we want to delete
    func deletePerson(atIndex index: Int) {
        self.listPersons.remove(at: index)
    }
    
    
    // MARK: - Getters
    
    
    /// Get persons with a specific lastname
    ///
    /// - Parameter withLastname: lastname of the persons
    /// - Returns: return a tab of persons with the lastname
    func getPersonsByLastname(withLastname: String) -> [Personne] {
        var persons: [Personne] = []
        let context = CoreDataManager.getContext()
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        request.predicate = NSPredicate(format: "nom == %@", withLastname)
        do {
            try persons = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get persons by lastname=\(withLastname): \(error)")
        }
        return persons
    }
    
    /// Get persons with a specific lastname
    ///
    /// - Parameter withLastname: lastname of the persons
    /// - Returns: return a tab of persons with the lastname
    func getPersonsByUsername(withUsername: String) -> [Personne] {
        var persons: [Personne] = []
        let context = CoreDataManager.getContext()
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        request.predicate = NSPredicate(format: "pseudo == %@", withUsername)
        do {
            try persons = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get persons by lastname=\(withUsername): \(error)")
        }
        return persons
    }
    
    /// Get all the persons is the DB
    ///
    /// - Returns: array of persons
    func getAllPersons() -> [Personne] {
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
    
    /// Get a person on a specific index
    ///
    /// - Returns: a person
    func getPersonAtIndex(withIndex index: Int) -> Personne {
        return self.listPersons[index]
    }



}
