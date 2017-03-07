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
    
    var pseudo : String{
        get{
            let prenom : String = self.prenom ?? ""
            let nom : String = self.nom ?? ""
            return prenom+"."+nom
        }
    }
    
    @discardableResult
    static func createNewPersonne(firstName: String, name: String, tel: String, city: String, pwd: String, image: NSData) -> Personne{
        let context = CoreDataManager.getContext()
        //create a person
        let person = Personne(context: context)
        //save datas into the person
        person.nom = name
        person.prenom = firstName
        person.tel = tel
        person.ville = city
        person.mdp = pwd
        person.photo = image
        return person
    }
    
    
    
}
