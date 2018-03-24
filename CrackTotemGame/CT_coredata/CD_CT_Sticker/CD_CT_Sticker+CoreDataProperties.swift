//
//  CD_CT_Sticker+CoreDataProperties.swift
//  StickersApp
//
//  Created by Marko Dimitrijevic on 06/03/2018.
//  Copyright © 2018 Dragan Krtalic. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_CT_Sticker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_CT_Sticker> {
        return NSFetchRequest<CD_CT_Sticker>(entityName: "CD_CT_Sticker")
    }

    @NSManaged public var claimed: Bool
    @NSManaged public var count4Cripto: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var numOfRows: NSNumber?
    @NSManaged public var sid: NSNumber
    @NSManaged public var sort: NSNumber?
    @NSManaged public var ver: NSNumber?
    @NSManaged public var rows: NSSet
    @NSManaged public var totem: CDCrackTotem

}

// MARK: Generated accessors for rows
extension CD_CT_Sticker {

    @objc(addRowsObject:)
    @NSManaged public func addToRows(_ value: CD_CT_Row)

    @objc(removeRowsObject:)
    @NSManaged public func removeFromRows(_ value: CD_CT_Row)

    @objc(addRows:)
    @NSManaged public func addToRows(_ values: NSSet)

    @objc(removeRows:)
    @NSManaged public func removeFromRows(_ values: NSSet)

}
