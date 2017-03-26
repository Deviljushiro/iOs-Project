//
//  Information.swift
//  iOs-Project
//
//  Created by JeanMi on 24/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/* INFORMATION will regroup documents and important mail or shared news */

extension Information {
    
    
    // MARK: - CRUD
    
    @discardableResult
    /// Create a new info in the DB
    ///
    /// - Parameters:
    ///   - title: of the information
    ///   - body: of the information
    ///   - url: of the information
    ///   - picture: of the information
    ///   - date: creation of the information
    static func createNewInfo(title: String, body: String, url: String, picture: NSData, KW: String){
        //create an info
        let info = Information(context: CoreDataManager.context)
        //save datas into the promo
        info.titre = title
        info.desc = body
        info.lien = url
        info.image = picture
        info.dateCreation = DateManager.currentDateString()
        info.possede = MotClefSet.getKWByWord(word: KW)
        CoreDataManager.save()
    }
    
    
}

