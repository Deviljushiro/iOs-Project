//
//  MotClef.swift
//  iOs-Project
//
//  Created by JeanMi on 26/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/* INFORMATION will regroup documents and important mail or shared news */

extension MotClef {
    
    
    // MARK: - CRUD
    
    @discardableResult
    /// Create a new keyword in the DB
    ///
    /// - Parameters:
    ///   - word: the future keyword
    static func createNewKeyword(word: String){
        //create an info
        let keyword = MotClef(context: CoreDataManager.context)
        //save datas into the promo
        keyword.mot = word
        CoreDataManager.save()
    }

}
