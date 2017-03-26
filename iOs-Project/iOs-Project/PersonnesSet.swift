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
    
    // MARK: - Core Data constants
    
    let context = CoreDataManager.context
    let request : NSFetchRequest<Personne> = Personne.fetchRequest()
    
    // MARK: - Variables
    
    fileprivate lazy var personsFetched : NSFetchedResultsController<Personne> = {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Personne.nom),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()

    
    // MARK: - Initialization
    
    init(){
        do {
            try personsFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get persons\(error)")
        }
    }
    
    /// Initialize the messages by fetching according to a group
    ///
    /// - Parameter group: messages's group
    init(promo: Promo){
        personsFetched = valueForPersonFetched(promo: promo)
        do {
            try personsFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get students\(error)")
        }
    }
    
    // MARK: - Help methods

    /// Re-perform the fetch for the NSFetchResult
    func refreshPersons(){
        do {
            try personsFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get persons\(error)")
        }
        
    }
    
    /// Give a fetchResultController value to personFetched according to a promo
    ///
    /// - Parameter promo: group we want to get the students
    /// - Returns: NSFetchResultController of the promo's students
    func valueForPersonFetched(promo: Promo) -> NSFetchedResultsController<Personne> {
        request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Personne.nom),ascending:true)]
        request.predicate = NSPredicate(format: "promo == %@", promo)
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }

    
    // MARK: - Getters
    
    func getPersons() -> NSFetchedResultsController<Personne>  {
        
        return personsFetched
    }
    
    /// Get persons with a specific lastname
    ///
    /// - Parameter withLastname: lastname of the persons
    /// - Returns: return a tab of persons with the lastname
    func getPersonsByLastname(withLastname: String) -> [Personne] {
        var persons: [Personne] = []
        let context = CoreDataManager.context
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        request.predicate = NSPredicate(format: "nom == %@", withLastname)
        do {
            try persons = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get persons by lastname=\(withLastname): \(error)")
        }
        return persons
    }
    
    /// Get persons with a specific username
    ///
    /// - Parameter withUsername: username of the persons
    /// - Returns: return a tab of persons with the username
    class func getPersonsByUsername(withUsername: String) -> Personne? {
        var persons: [Personne] = []
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        request.predicate = NSPredicate(format: "pseudo == %@", withUsername)
        do {
            try persons = CoreDataManager.context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get persons by username=\(withUsername): \(error)")
        }
        if persons == [] {
            return nil
        }
        else {
            return persons[0]
        }
    }
    
    /// Get all the persons is the DB
    ///
    /// - Returns: array of persons
    func getAllPersons() -> [Personne] {
        var persons: [Personne] = []
        let context = CoreDataManager.context
        let request : NSFetchRequest<Personne> = Personne.fetchRequest()
        do {
            try persons = context.fetch(request)
        } catch let error as NSError {
            print(error)
        }
        return persons
    }
    




}
