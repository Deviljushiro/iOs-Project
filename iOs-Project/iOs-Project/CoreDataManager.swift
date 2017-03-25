//
//  CoreDataManager.swift
//  iOs-Project
//
//  Created by JeanMi on 16/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    
    /// get context from Application
    ///
    /// - Returns: NSManagedObjectContext of core data in the appdelegate
    static var context : NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { exit(EXIT_FAILURE) }
        return appDelegate.persistentContainer.viewContext
    }()
    
    
    
    /// Try to save the context
    ///
    /// - Returns: an error if the save failed, else nothing
    @discardableResult
    class func save() -> NSError? {
        //try to save it
        do {
            try CoreDataManager.context.save()
            return nil
        }
        catch let error as NSError{
            return error
        }
    }
    
    
    
}
