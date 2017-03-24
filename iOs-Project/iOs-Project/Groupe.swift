//
//  Groupe.swift
//  iOs-Project
//
//  Created by JeanMi on 19/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Groupe{
    
    // MARK: - CRUD
    
    /// Create a new group in the DB
    ///
    /// - Parameters:
    ///   - name : name we want for the group
    static func createNewGroup(name n: String){
        
        let group = Groupe(context: CoreDataManager.getContext())
        //save datas into the group
        group.name=n
        group.id=Groupe.autoIncrementGroups();
        //save him
        CoreDataManager.save()

    }
    
    static func autoIncrementGroups() -> Int64{
        return GroupesSet.getNumbersOfGroups()+1
    }
}
