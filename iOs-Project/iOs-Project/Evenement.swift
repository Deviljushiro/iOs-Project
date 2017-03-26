//
//  Evenement.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 25/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit


extension Evenement {
    
    
    // MARK: - CRUD
    
    @discardableResult
    /// Create a new event in the DB
    ///
    /// - Parameters:
    ///   - title: of the event
    ///   - body: of the event
    ///   - start: date of the event
    ///   - end: date of the event
    static func createNewEvent(title: String, body: String, start: Date, end: Date){
        //create an info
        let event = Evenement(context: CoreDataManager.context)
        //save datas into the promo
        event.titre = title
        event.desc = body
        //convert the dates
        event.dateDebut = start as NSDate?
        event.dateFin = end as NSDate?
        CoreDataManager.save()
    }
}
