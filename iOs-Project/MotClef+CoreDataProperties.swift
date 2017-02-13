//
//  MotClef+CoreDataProperties.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension MotClef {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotClef> {
        return NSFetchRequest<MotClef>(entityName: "MotClef");
    }

    @NSManaged public var id: Int16
    @NSManaged public var mot: String?
    @NSManaged public var concerner: NSSet?

}

// MARK: Generated accessors for concerner
extension MotClef {

    @objc(addConcernerObject:)
    @NSManaged public func addToConcerner(_ value: Document)

    @objc(removeConcernerObject:)
    @NSManaged public func removeFromConcerner(_ value: Document)

    @objc(addConcerner:)
    @NSManaged public func addToConcerner(_ values: NSSet)

    @objc(removeConcerner:)
    @NSManaged public func removeFromConcerner(_ values: NSSet)

}
