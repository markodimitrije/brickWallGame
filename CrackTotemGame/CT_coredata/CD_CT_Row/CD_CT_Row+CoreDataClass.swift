//
//  CD_CT_Row+CoreDataClass.swift
//  trySaveJSONtoComplexCoreData
//
//  Created by Marko Dimitrijevic on 03/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
//

import UIKit
import CoreData


public class CD_CT_Row: NSManagedObject {

    func getCellsFor(row: Row, ctx: NSManagedObjectContext) -> Set<CD_CT_Cell> {
        
        var cdCells = Set<CD_CT_Cell>()
        
        for cell in row.cells {
            
            let cdCell = CD_CT_Cell.init(entity: CD_CT_Cell.entity(), insertInto: ctx)
            
            cdCell.cId = NSNumber.init(value: cell.cId)
            cdCell.w = NSNumber.init(value: cell.w)
            cdCell.o = NSNumber.init(value: cell.o)
            cdCell.p = NSNumber.init(value: cell.p)
            cdCell.b = NSNumber.init(value: cell.b)
            cdCell.t = NSNumber.init(value: cell.t)
            cdCell.txt = cell.txt
            
            cdCell.row = self // povezi relation od parent-a: Row -> Cells
            
            cdCells.insert(cdCell) // nema append nego insert
            
        }
        return cdCells
        
    }
    
    func getCellsFor(rowId: Int, sid: Int, ctx: NSManagedObjectContext) -> [Cell] {

        let fReq: NSFetchRequest<CD_CT_Row> = CD_CT_Row.fetchRequest()
        fReq.predicate = NSPredicate.init(format: "%K==%i && %K==%i", "rowId", rowId, "sticker.sid", sid)
        
        
        var cd_ct_row: CD_CT_Row?
        
        do {
            let cd_ct_rows = try ctx.fetch(fReq)
            cd_ct_row = cd_ct_rows.first
        } catch {
            print("getCellsFor. cant fetch")
        }
        
        guard let row = cd_ct_row else {
            return [ ]
        }
        
        var cells = [Cell]()
        
        for cdCell in row.cells {
            
            if let cd_ct_cell = cdCell as? CD_CT_Cell {
            
                let cId = Int.init(truncating: cd_ct_cell.cId!)
                let w = Int.init(truncating: cd_ct_cell.w!)
                let o = Int.init(truncating: cd_ct_cell.o!)
                let p = Int.init(truncating: cd_ct_cell.p!)
                let b = Int.init(truncating: cd_ct_cell.b!)
                let t = Int.init(truncating: cd_ct_cell.t!)
                let txt = cd_ct_cell.txt!
                
                let c = Cell.init(cId: cId, w: w, o: o, p: p, b: b, t: t, txt: txt)
                
                cells.append(c)
            }
            
        }
        
        return cells.sorted(by: {$0.cId < $1.cId})
        
    }
    
    func updadeOnlyRowVars(row: Row) {
        self.numOfElements = NSNumber.init(value: row.numOfElements)
        self.rowId = NSNumber.init(value: row.rowId)
    }
    
}





// MARK: - ConformToEquatable

func == (lhs: CD_CT_Row, rhs: CD_CT_Row) -> Bool {
    return lhs.rowId == rhs.rowId && lhs.sticker.sid == rhs.sticker.sid
}

func != (lhs: CD_CT_Row, rhs: CD_CT_Row) -> Bool {
    return lhs.rowId != rhs.rowId || lhs.sticker.sid != rhs.sticker.sid
}
