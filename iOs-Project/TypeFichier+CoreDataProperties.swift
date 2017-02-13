//
//  TypeFichier+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TypeFichier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TypeFichier> {
        return NSFetchRequest<TypeFichier>(entityName: "TypeFichier");
    }

    @NSManaged public var id: Int16
    @NSManaged public var libelle: String?
    @NSManaged public var contenir: NSSet?

}

// MARK: Generated accessors for contenir
extension TypeFichier {

    @objc(addContenirObject:)
    @NSManaged public func addToContenir(_ value: Fichier)

    @objc(removeContenirObject:)
    @NSManaged public func removeFromContenir(_ value: Fichier)

    @objc(addContenir:)
    @NSManaged public func addToContenir(_ values: NSSet)

    @objc(removeContenir:)
    @NSManaged public func removeFromContenir(_ values: NSSet)

}
