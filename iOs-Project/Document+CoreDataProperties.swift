//
//  Document+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document");
    }

    @NSManaged public var contenu: NSData?
    @NSManaged public var id: Int16
    @NSManaged public var nom: String?
    @NSManaged public var contenir: NSSet?
    @NSManaged public var postePar: Personne?

}

// MARK: Generated accessors for contenir
extension Document {

    @objc(addContenirObject:)
    @NSManaged public func addToContenir(_ value: MotClef)

    @objc(removeContenirObject:)
    @NSManaged public func removeFromContenir(_ value: MotClef)

    @objc(addContenir:)
    @NSManaged public func addToContenir(_ values: NSSet)

    @objc(removeContenir:)
    @NSManaged public func removeFromContenir(_ values: NSSet)

}
