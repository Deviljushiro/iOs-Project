//
//  Fichier+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Fichier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fichier> {
        return NSFetchRequest<Fichier>(entityName: "Fichier");
    }

    @NSManaged public var contenu: NSData?
    @NSManaged public var id: Int16
    @NSManaged public var nom: String?
    @NSManaged public var taille: Double
    @NSManaged public var attribute: NSObject?
    @NSManaged public var attribute1: NSObject?
    @NSManaged public var etreDans: Message?
    @NSManaged public var etreUn: TypeFichier?

}
