//
//  Promo.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 21/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Promo {
    
    
    // MARK: - CRUD
    
    @discardableResult
    /// Create a new promo in the DB
    ///
    /// - Parameters:
    ///   - year: year of the promo
    static func createNewPromo(year: String){
        //create a promo
        let promo = Promo(context: CoreDataManager.context)
        //save datas into the promo
        promo.annee = year
        CoreDataManager.save()
    }

    
}
