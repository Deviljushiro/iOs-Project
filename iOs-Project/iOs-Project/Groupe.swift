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
    
    /// Create a new group in the DB
    ///
    /// - Parameters:
    ///   - name : name we want for the group
    func createNewGroup(name n: String){
        
        let group = Groupe(context: CoreDataManager.getContext())
        //save datas into the group
        group.name=name
        group.id=autoIncrementGroups();
        //save him
        CoreDataManager.save()

    }
    
    func autoIncrementGroups() -> Int64{
        return GroupesSet.getNumbersOfMessages()+1
    }
}
