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
        //create a person
        let person = Personne(context: CoreDataManager.context)
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
        //Manage the different groups according to the role of the person
        let globalGroup = GroupesSet.getGroupByName(groupName: "All")
        person.addToAppartenir(globalGroup!) //Add the person to the Global group
        
        //We will add the person to the group corresponding to his fonction, the group is created if it doesn't already exist
        if isRespo { //RESPO GROUP
            if GroupesSet.getGroupByName(groupName:"responsable") == nil{
                Groupe.createNewGroup(name: "responsable")
            }
            person.addToAppartenir(GroupesSet.getGroupByName(groupName:"responsable")!)
        }
        if isTeacher{ //TEACHER GROUP
            if GroupesSet.getGroupByName(groupName:"professeurs") == nil{   //
                Groupe.createNewGroup(name: "professeurs")
            }
            person.addToAppartenir(GroupesSet.getGroupByName(groupName:"professeurs")!)
        }
        if isSecretary { //SECRETARY GROUP
            if GroupesSet.getGroupByName(groupName:"secretaire") == nil{
                Groupe.createNewGroup(name: "secretaire")
            }
            person.addToAppartenir(GroupesSet.getGroupByName(groupName:"secretaire")!)
        }
        if isStudent { //STUDENT GROUP
            if GroupesSet.getGroupByName(groupName:"etudiant") == nil{
                Groupe.createNewGroup(name: "etudiant")
            }
            person.addToAppartenir(GroupesSet.getGroupByName(groupName:"etudiant")!)
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
        return (self.estRespo || self.estSecretaire)
    }
    
    /// If the person is a student
    ///
    /// - Returns: True if he is, else False
    func isStudent() -> Bool {
        return (self.estEleve)
    }
    
    /// If the person is a secretary
    ///
    /// - Returns: True if he is, else False
    func isSecretary() -> Bool {
        return (self.estSecretaire)
    }
    
    /// If the person is a teacher
    ///
    /// - Returns: True if he is, else False
    func isTeacher() -> Bool {
        return (self.estProf)
    }
    /// If the person is a respo
    ///
    /// - Returns: True if he is, else False
    func isRespo() -> Bool {
        return (self.estRespo)
    }
    
    /// Get the role of the person
    ///
    /// - Returns: the role on string form
    func getFonction() -> String {
        var fonction: String
        if self.isStudent() {
            fonction = "Etudiant"
        }
        else if self.isSecretary() {
            fonction = "Secrétaire"
        }
        else {
            if self.isRespo() {
                fonction = "Enseignante Responsable"
            }
            else {
                fonction = "Enseignant"
            }
        }
        return fonction
    }
    
    
}
