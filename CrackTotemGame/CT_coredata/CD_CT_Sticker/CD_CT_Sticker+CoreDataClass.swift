//
//  CD_CT_Sticker+CoreDataClass.swift
//  trySaveJSONtoComplexCoreData
//
//  Created by Marko Dimitrijevic on 03/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
//

import UIKit
import CoreData


public class CD_CT_Sticker: NSManagedObject {

    func getRowsFor(sticker: CrackTotemSticker, ctx: NSManagedObjectContext) -> Set<CD_CT_Row> {
        
        var cdRows = Set<CD_CT_Row>()
        
        for r in sticker.rows {
            
            let cdRow = CD_CT_Row.init(entity: CD_CT_Row.entity(), insertInto: ctx)
            
            cdRow.rowId = NSNumber.init(value: r.rowId)
            cdRow.numOfElements = NSNumber.init(value: r.numOfElements)
            
            cdRow.cells = NSSet.init(set: cdRow.getCellsFor(row: r, ctx: ctx))
            
            cdRow.sticker = self // povezi relation od parent-a: Sticker -> Rows
            
            cdRows.insert(cdRow)
            
        }
        
//        print("getRowsFor.cdRows.count = \(cdRows.count)")
        return cdRows
        
    }
    
    
    func getRowsFor(stickerSid sid: Int, ctx: NSManagedObjectContext) -> [Row] {
        
        let fReq: NSFetchRequest<CD_CT_Sticker> = CD_CT_Sticker.fetchRequest()
        fReq.predicate = NSPredicate.init(format: "%K==%i", "sid", sid)
        
        var cd_ct_sticker: CD_CT_Sticker?
        
        do {
            let cd_ct_stickers = try ctx.fetch(fReq)
            cd_ct_sticker = cd_ct_stickers.first
        } catch {
            print("getRowsFor. cant fetch")
        }
        
        guard let sticker = cd_ct_sticker else { return [ ] }
        
        var rows = [Row]()
        
        for r in sticker.rows {
            
            if let cd_ct_row = r as? CD_CT_Row {
                
                let rowId = Int.init(truncating: cd_ct_row.rowId!)
                let numOfElements = Int.init(truncating: cd_ct_row.numOfElements!)
                
                let cells = cd_ct_row.getCellsFor(rowId: rowId, sid: sid, ctx: ctx)
                
                let r = Row.init(rowId: rowId, numOfElements: numOfElements, cells: cells)
                
                rows.append(r)
                
            }
            
        }
        
        return rows.sorted(by: {$0.rowId < $1.rowId})
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
