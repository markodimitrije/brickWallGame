//
//  CD_CT_Cell+CoreDataProperties.swift
//  StickersApp
//
//  Created by Marko Dimitrijevic on 06/03/2018.
//  Copyright © 2018 Dragan Krtalic. All rights reserved.
//
//

import Foundation
import CoreData


extension CD_CT_Cell {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CD_CT_Cell> {
        return NSFetchRequest<CD_CT_Cell>(entityName: "CD_CT_Cell")
    }

    @NSManaged public var b: NSNumber?
    @NSManaged public var cId: NSNumber?
    @NSManaged public var o: NSNumber?
    @NSManaged public var p: NSNumber?
    @NSManaged public var t: NSNumber?
    @NSManaged public var txt: String?
    @NSManaged public var w: NSNumber?
    @NSManaged public var row: CD_CT_Row

}
