//
//  Message+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var contenu: String?
    @NSManaged public var dateEnvoi: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var concerner: Groupe?
    @NSManaged public var contenir: NSSet?
    @NSManaged public var ecritPar: Personne?

}

// MARK: Generated accessors for contenir
extension Message {

    @objc(addContenirObject:)
    @NSManaged public func addToContenir(_ value: Fichier)

    @objc(removeContenirObject:)
    @NSManaged public func removeFromContenir(_ value: Fichier)

    @objc(addContenir:)
    @NSManaged public func addToContenir(_ values: NSSet)

    @objc(removeContenir:)
    @NSManaged public func removeFromContenir(_ values: NSSet)

}
