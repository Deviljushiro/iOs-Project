//
//  Promo+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Promo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Promo> {
        return NSFetchRequest<Promo>(entityName: "Promo");
    }

    @NSManaged public var annee: Int16
    @NSManaged public var contient: NSSet?

}

// MARK: Generated accessors for contient
extension Promo {

    @objc(addContientObject:)
    @NSManaged public func addToContient(_ value: Eleve)

    @objc(removeContientObject:)
    @NSManaged public func removeFromContient(_ value: Eleve)

    @objc(addContient:)
    @NSManaged public func addToContient(_ values: NSSet)

    @objc(removeContient:)
    @NSManaged public func removeFromContient(_ values: NSSet)

}
