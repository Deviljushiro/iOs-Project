//
//  CategoriePersonne+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CategoriePersonne {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoriePersonne> {
        return NSFetchRequest<CategoriePersonne>(entityName: "CategoriePersonne");
    }

    @NSManaged public var libelle: String?
    @NSManaged public var concerne: NSSet?

}

// MARK: Generated accessors for concerne
extension CategoriePersonne {

    @objc(addConcerneObject:)
    @NSManaged public func addToConcerne(_ value: Personne)

    @objc(removeConcerneObject:)
    @NSManaged public func removeFromConcerne(_ value: Personne)

    @objc(addConcerne:)
    @NSManaged public func addToConcerne(_ values: NSSet)

    @objc(removeConcerne:)
    @NSManaged public func removeFromConcerne(_ values: NSSet)

}
