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
    static func createNewEvent(title: String, body: String, start: String, end: String){
        //create an info
        let event = Evenement(context: CoreDataManager.context)
        //save datas into the promo
        event.titre = title
        event.desc = body
        event.dateDebut = start
        event.dateFin = end
        CoreDataManager.save()
    }
}
