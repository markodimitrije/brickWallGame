//
//  CD_CT_Row+CoreDataProperties.swift
//  StickersApp
//
//  Created by Marko Dimitrijevic on 06/03/2018.
//  Copyright © 2018 Dragan Krtalic. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_CT_Row {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_CT_Row> {
        return NSFetchRequest<CD_CT_Row>(entityName: "CD_CT_Row")
    }

    @NSManaged public var numOfElements: NSNumber?
    @NSManaged public var rowId: NSNumber?
    @NSManaged public var cells: NSSet
    @NSManaged public var sticker: CD_CT_Sticker

}

// MARK: Generated accessors for cells
extension CD_CT_Row {

    @objc(addCellsObject:)
    @NSManaged public func addToCells(_ value: CD_CT_Cell)

    @objc(removeCellsObject:)
    @NSManaged public func removeFromCells(_ value: CD_CT_Cell)

    @objc(addCells:)
    @NSManaged public func addToCells(_ values: NSSet)

    @objc(removeCells:)
    @NSManaged public func removeFromCells(_ values: NSSet)

}
