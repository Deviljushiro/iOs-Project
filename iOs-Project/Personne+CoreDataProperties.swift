//
//  Personne+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Personne {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Personne> {
        return NSFetchRequest<Personne>(entityName: "Personne");
    }

    @NSManaged public var mdp: String?
    @NSManaged public var nom: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var prenom: String?
    @NSManaged public var pseudo: String?
    @NSManaged public var appartenir: NSSet?
    @NSManaged public var ecrire: NSSet?
    @NSManaged public var estUn: CategoriePersonne?
    @NSManaged public var poster: NSSet?

}

// MARK: Generated accessors for appartenir
extension Personne {

    @objc(addAppartenirObject:)
    @NSManaged public func addToAppartenir(_ value: Groupe)

    @objc(removeAppartenirObject:)
    @NSManaged public func removeFromAppartenir(_ value: Groupe)

    @objc(addAppartenir:)
    @NSManaged public func addToAppartenir(_ values: NSSet)

    @objc(removeAppartenir:)
    @NSManaged public func removeFromAppartenir(_ values: NSSet)

}

// MARK: Generated accessors for ecrire
extension Personne {

    @objc(addEcrireObject:)
    @NSManaged public func addToEcrire(_ value: Message)

    @objc(removeEcrireObject:)
    @NSManaged public func removeFromEcrire(_ value: Message)

    @objc(addEcrire:)
    @NSManaged public func addToEcrire(_ values: NSSet)

    @objc(removeEcrire:)
    @NSManaged public func removeFromEcrire(_ values: NSSet)

}

// MARK: Generated accessors for poster
extension Personne {

    @objc(addPosterObject:)
    @NSManaged public func addToPoster(_ value: Document)

    @objc(removePosterObject:)
    @NSManaged public func removeFromPoster(_ value: Document)

    @objc(addPoster:)
    @NSManaged public func addToPoster(_ values: NSSet)

    @objc(removePoster:)
    @NSManaged public func removeFromPoster(_ values: NSSet)

}
