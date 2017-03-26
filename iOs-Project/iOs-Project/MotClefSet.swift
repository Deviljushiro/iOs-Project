//
//  MotClefSet.swift
//  iOs-Project
//
//  Created by JeanMi on 26/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MotClefSet {
    
    // MARK: - Core Data constants
    
    let context = CoreDataManager.context
    let request : NSFetchRequest<MotClef> = MotClef.fetchRequest()
    
    // MARK: - Variables
    
    fileprivate lazy var KWFetched : NSFetchedResultsController<MotClef> = {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(MotClef.mot),ascending:false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    // MARK: - Initialization
    
    /// Initialize the info fetched with all datas
    init(){
        do {
            try KWFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get keywords\(error)")
        }
    }
    
    // MARK: - Getters
    
    /// Get all the keywords fetched
    ///
    /// - Returns: keywordFetched
    func getKW() -> NSFetchedResultsController<MotClef>  {
        return self.KWFetched
    }
    
    /// Get a keyword from a specific word
    ///
    /// - Parameter word: we want to get
    /// - Returns: the corresponding word
    class func getKWByWord(word: String) -> MotClef? {
        var kws: [MotClef] = []
        let context = CoreDataManager.context
        let request : NSFetchRequest<MotClef> = MotClef.fetchRequest()
        request.predicate = NSPredicate(format: "mot == %@", word)
        do {
            try kws = context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get keywords by word=\(word): \(error)")
        }
        if kws==[] {
            return nil
        }
        else {
            return kws[0]
        }
    }

}
