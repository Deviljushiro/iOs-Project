//
//  Groupe+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Groupe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Groupe> {
        return NSFetchRequest<Groupe>(entityName: "Groupe");
    }

    @NSManaged public var dateCreation: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var titre: String?
    @NSManaged public var concerner: NSSet?
    @NSManaged public var contenir: NSSet?

}

// MARK: Generated accessors for concerner
extension Groupe {

    @objc(addConcernerObject:)
    @NSManaged public func addToConcerner(_ value: Personne)

    @objc(removeConcernerObject:)
    @NSManaged public func removeFromConcerner(_ value: Personne)

    @objc(addConcerner:)
    @NSManaged public func addToConcerner(_ values: NSSet)

    @objc(removeConcerner:)
    @NSManaged public func removeFromConcerner(_ values: NSSet)

}

// MARK: Generated accessors for contenir
extension Groupe {

    @objc(addContenirObject:)
    @NSManaged public func addToContenir(_ value: Message)

    @objc(removeContenirObject:)
    @NSManaged public func removeFromContenir(_ value: Message)

    @objc(addContenir:)
    @NSManaged public func addToContenir(_ values: NSSet)

    @objc(removeContenir:)
    @NSManaged public func removeFromContenir(_ values: NSSet)

}
