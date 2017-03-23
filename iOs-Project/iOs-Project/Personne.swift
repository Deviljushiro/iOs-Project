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
    ///   - isStudent: if he's a student
    ///   - isTeacher: if he's a teacher
    ///   - isSecretary: if he's a secretary
    ///   - isRespo: if he's the respo of IG
    /// - Returns: the person created
    static func createNewPersonne(firstName: String, name: String, tel: String, city: String, pwd: String, image: NSData, isStudent: Bool, isTeacher: Bool, isSecretary: Bool, isRespo: Bool, promo: String){
        //create the group that will be given
        //let group: NSSet = []
        //group.adding(GroupesSet.getGroupByName(groupName:)
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
        person.estEleve = isStudent
        person.estProf = isTeacher
        person.estSecretaire = isSecretary
        person.estRespo = isRespo
       
        if isRespo
        {
            if GroupesSet.getGroupByName(groupName:"responsable") == nil{
                Groupe.createNewGroup(name: "responsable")
            }

            person.addToAppartenir(GroupesSet.getGroupByName(groupName:"responsable")!)
            //group.adding(GroupesSet.getGroupByName(groupName:"responsable")!)
        }
        if isTeacher{
            if GroupesSet.getGroupByName(groupName:"professeurs") == nil{
                Groupe.createNewGroup(name: "professeurs")
            }

            person.addToAppartenir(GroupesSet.getGroupByName(groupName:"professeurs")!)
            //group.adding(GroupesSet.getGroupByName(groupName:"professeurs")!)
        }
        if isSecretary
        {
            if GroupesSet.getGroupByName(groupName:"secretaire") == nil{
                Groupe.createNewGroup(name: "secretaire")
            }

            person.addToAppartenir(GroupesSet.getGroupByName(groupName:"secretaire")!)
            //group.adding(GroupesSet.getGroupByName(groupName:"secretaires")!)
        }
        if isStudent
        {
            if GroupesSet.getGroupByName(groupName:"etudiant") == nil{
                Groupe.createNewGroup(name: "etudiant")
            }

            person.addToAppartenir(GroupesSet.getGroupByName(groupName:"etudiant")!)
            //group.adding(GroupesSet.getGroupByName(groupName:"etudiant")!)
            if GroupesSet.getGroupByName(groupName:promo) == nil{
                Groupe.createNewGroup(name: promo)
            }
            person.addToAppartenir(GroupesSet.getGroupByName(groupName:promo)!)

        }
        //get the promo and add it to the person
        person.promo = PromoSet.getPromoByYear(year: promo)
        //save him
        CoreDataManager.save()
    }
    
    // MARK: - Getters
    
    /// If the person is an admin or not
    ///
    /// - Returns: True if he is, else False
    func isAdmin() -> Bool {
        return self.estRespo
    }
    
    
    
}
