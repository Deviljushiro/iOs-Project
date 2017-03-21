//
//  PromoSet.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 21/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PromoSet {
    
    // MARK: - Core Data constants
    
    let context = CoreDataManager.getContext()
    let request : NSFetchRequest<Promo> = Promo.fetchRequest()
    
    // MARK: - Variables
    
    fileprivate lazy var promoFetched : NSFetchedResultsController<Promo> = {
        self.request.sortDescriptors = [NSSortDescriptor(key:#keyPath(Promo.annee),ascending:true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: CoreDataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()

    // MARK : - Initialization
    
    init(){
        do {
            try promoFetched.performFetch()
        }
        catch let error as NSError{
            fatalError("failed to get promos\(error)")
        }
    }
    
    
    //MARK : - Getters
    
    /// Get the promo according to a specific year
    ///
    /// - Parameter year: of the promo
    /// - Returns: the promo corresponding
    class func getPromoByYear(year: String) -> Promo? {
        var promos: [Promo] = []
        let request : NSFetchRequest<Promo> = Promo.fetchRequest()
        request.predicate = NSPredicate(format: "annee == %@", year)
        do {
            try promos = CoreDataManager.context.fetch(request)
        } catch let error as NSError {
            fatalError("failed to get promo by year=\(year): \(error)")
        }
        if promos == [] {
            return nil
        }
        else {
            return promos[0]
        }
        
    }
    
}
