//
//  Personne.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 22/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Personne {
    
    // MARK: - Variables
    
    var fullname : String{
        get{
            let prenom = self.prenom ?? ""
            let nom = self.nom ?? ""
            return prenom+" "+nom
        }
    }
    
    // MARK: - CRUD
    
    @discardableResult
    /// Create a new person in the DB
    ///
    /// - Parameters:
    ///   - firstName: of the person
    ///   - name: of the person
    ///   - tel: of the person
    ///   - city: of the person
    ///   - pwd: of the person
    ///   - image: of the person
    /// - Returns: the person created
    static func createNewPersonne(firstName: String, name: String, tel: String, city: String, pwd: String, image: NSData){
        //create a person
        let person = Personne(context: CoreDataManager.getContext())
        //save datas into the person
        person.nom = name
        person.prenom = firstName
        person.tel = tel
        person.ville = city
        person.mdp = pwd
        person.photo = image
        person.pseudo = firstName+"."+name
        CoreDataManager.save()
    }
    
    
    
}
