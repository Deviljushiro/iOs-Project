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
    
    /// Initialize the info fetched with all datas
    init(){
        do {
            try infoFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get promos\(error)")
        }
    }
    
    /// Initialize the info fetched with all infos containing a title
    ///
    /// - Parameter title: for the search
    init(title: String){
        self.infoFetched = self.valueForInfoFetchedByTitle(title: title)
        do {
            try infoFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get infos\(error)")
        }
    }
    
    /// Initialize the info fetched with all infos for a keyword
    ///
    /// - Parameter keyword: for the search
    init(keyword: String){
        self.infoFetched = self.valueForInfoFetchedByKW(keyword: keyword)
        do {
            try infoFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get infos\(error)")
        }
    }
    
    /// Initialize the info fetched with all infos for a keyword and containing a title
    ///
    /// - Parameter keyword: for the search
    init(keyword: String, title: String){
        self.infoFetched = self.valueForInfoFetchedByKWAndTitle(keyword: keyword, title: title)
        do {
            try infoFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get infos\(error)")
        }
    }
    
    // MARK: - Help methods
    
    /// Re-perform the fetch
    func refresh() {
        do {
            try infoFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get infos\(error)")
        }

    }
    
    /// Give a fetchResultController value to info fetched according to specific title
    ///
    /// - Parameter title: input for the search
    /// - Returns: NSFetchResultController of the info
    func valueForInfoFetchedByTitle(title: String) -> NSFetchedResultsController<Information> {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Information.titre),ascending:true)]
        self.request.predicate = NSPredicate(format: "titre CONTAINS %@", title)
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    /// Give a fetchResultController value to info fetched according to specific keyword
    ///
    /// - Parameter keyword: input for the search
    /// - Returns: NSFetchResultController of the info
    func valueForInfoFetchedByKW(keyword:String) -> NSFetchedResultsController<Information> {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Information.titre),ascending:true)]
        self.request.predicate = NSPredicate(format: "possede.mot ==  %@", keyword)
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
    
    /// Give a fetchResultController value to info fetched according to specific keyword and title
    ///
    /// - Parameter keyword: input for the search
    /// - Parameter title: input for the search
    /// - Returns: NSFetchResultController of the info
    func valueForInfoFetchedByKWAndTitle(keyword: String, title: String) -> NSFetchedResultsController<Information> {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Information.titre),ascending:true)]
        self.request.predicate = NSPredicate(format: "titre CONTAINS %@ and possede.mot == %@",title,keyword)
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
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
    class func getInfosByGroup(group: Groupe) -> [Information] {
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
