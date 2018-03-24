//
//  CDCrackTotem+CoreDataProperties.swift
//  StickersApp
//
//  Created by Marko Dimitrijevic on 06/03/2018.
//  Copyright © 2018 Dragan Krtalic. All rights reserved.
//
//

import Foundation
import CoreData


extension CDCrackTotem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCrackTotem> {
        return NSFetchRequest<CDCrackTotem>(entityName: "CDCrackTotem")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var numOfStk: NSNumber?
    @NSManaged public var tmplId: NSNumber?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var userId: String?
    @NSManaged public var val: NSNumber?
    @NSManaged public var version: NSNumber?
    @NSManaged public var stickers: NSSet

}

// MARK: Generated accessors for stickers
extension CDCrackTotem {

    @objc(addStickersObject:)
    @NSManaged public func addToStickers(_ value: CD_CT_Sticker)

    @objc(removeStickersObject:)
    @NSManaged public func removeFromStickers(_ value: CD_CT_Sticker)

    @objc(addStickers:)
    @NSManaged public func addToStickers(_ values: NSSet)

    @objc(removeStickers:)
    @NSManaged public func removeFromStickers(_ values: NSSet)

}
