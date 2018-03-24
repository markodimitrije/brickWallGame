//
//  CDCrackTotem+CoreDataClass.swift
//  trySaveJSONtoComplexCoreData
//
//  Created by Marko Dimitrijevic on 03/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
//

import UIKit
import CoreData

public class CDCrackTotem: NSManagedObject, Encodable {
    
    private func getStickerRecordWith(sid: Int, ctx: NSManagedObjectContext) -> CD_CT_Sticker? {
        
        let freq: NSFetchRequest<CD_CT_Sticker> = CD_CT_Sticker.fetchRequest()
        
        freq.predicate = NSPredicate.init(format: "%K==%i", "sid", sid)
        
        var result: CD_CT_Sticker?
        
        do {
            let results = try ctx.fetch(freq)
            result = results.first
        } catch {
            print("getCrackTotemSticker.catch -> nisam nasao CD_CT_Sticker za zadati SID!")
        }

//        print("getStickerRecordWith.result = \(result)")
        
        return result
        
    }
    
    
    // MARK: API - trazice ti StickersTotemVC - GET
    
    func getCrackTotemSticker(sid: Int?, ctx: NSManagedObjectContext) -> CrackTotemSticker? {
        
        guard let sid = sid, let record = getStickerRecordWith(sid: sid, ctx: ctx) else { return nil }
        
        let sort = Int.init(truncating: record.sort!);
        let id = Int.init(truncating: record.sid);
        let numOfRows = Int.init(truncating: record.numOfRows!);
        let ver = Int.init(truncating: record.ver!);
        let name = record.name!;
        let count4Cripto = Int.init(truncating: record.count4Cripto!);
        let claimed = record.claimed;
        
        let rows: [Row] = record.getRowsFor(stickerSid: id, ctx: ctx)
        
        let cts = CrackTotemSticker.init(sort: sort, sid: sid, numOfRows: numOfRows, ver: ver, name: name, rows: rows, count4Cripto: count4Cripto, claimed: claimed)
        
        return cts
        
    }
    
    
    
    // vrati mu sve objekte tipa CD_CT_Sticker koje imas u CoreData zapakovane u NSSet
    
//    func getAllCrackTotemStickers() -> NSSet? {
//
//        let freq: NSFetchRequest<CDCrackTotem> = CDCrackTotem.fetchRequest()
//        var res: CDCrackTotem?
//        do {
//            let results = try context.fetch(freq)
//            res = results.first
//        } catch {
//            print("getAllCrackTotemStickers.catch, cant fetch...")
//        }
//
//        print("getAllCrackTotemStickers.res?.stickers.count = \(String(describing: res?.stickers.count))")
//
//        return res?.stickers
//
//    }
    
    
    
    
    
    
    
    
    
    func createAllTotemStickersFor(cts: CrackTotemStructure, ctx: NSManagedObjectContext) -> Set<CD_CT_Sticker> {
        
        var cdTotemStickers = Set<CD_CT_Sticker>()
        
        for sticker in cts.stickers {
            
            let cdTotemSticker = CD_CT_Sticker.init(entity: CD_CT_Sticker.entity(), insertInto: ctx)
            
            updateStickerTotemLocalVars(record: cdTotemSticker, sticker: sticker)
            
            cdTotemSticker.rows = NSSet.init(set: cdTotemSticker.getRowsFor(sticker: sticker, ctx: ctx))
            
            cdTotemSticker.totem = self // povezi relation od parent-a: Totem -> Stickers
            
            cdTotemStickers.insert(cdTotemSticker)
            
        }
        //        print("getAllTotemStickersFor.cdTotemStickers.count = \(cdTotemStickers.count)")
        return cdTotemStickers
        
    }
    
    func getAllTotemStickersInfo() -> [Totem] { // ovo treba tableVC koji shows sve totems
        
        print("getAllTotemStickersInfo is CALLED !")
        
        var cdtStickers = [CD_CT_Sticker]()
        
        do {
            cdtStickers = try context.fetch(CD_CT_Sticker.fetchRequest())
        } catch {
            return [ ]
        }
        
        //guard let cdtStickers = Array.init(self.stickers) as? [CD_CT_Sticker] GLUPOST POPRILICNA
        
        let infos = cdtStickers.map { (s) -> Totem in
            let sid = Int.init(exactly: s.sid)!
            let name = s.name
            let claimed = s.claimed
            let (earned, required) = getEarnedAndRequiredTaps(cdtSticker: s)
            let sort = (s.sort != nil) ? Int.init(exactly: s.sort!)! : 0
            
            return Totem(sid: sid, name: name ?? "", o: earned, t: required, claimed: claimed, sort: sort)
        }

//        print("getAllTotemStickersInfo.vracam: infos = \(infos)")
        return infos
        
    }
    
    
    
    
    
    
    // MARK: API - trazice ti StickersTotemVC - 'POST'
    
    // treba da imam 2 API-ja: 1 - da moze da se update sa web-a (param je json)
    // 2 - da moze da se update iz local model-a (memory)
    
    // to-do: prodji kroz svaku cell u bazi, i trazi od modela u mem novi podatak!
    
    func updateStickerTotemToCoreData(totem: CrackTotemSticker?, ctx: NSManagedObjectContext) { // 2 -
        
        guard let totem = totem else { return }
        
        guard let s = getStickerRecordWith(sid: totem.sid, ctx: ctx) else { return } // uzmi record
        
        guard let cdRows = s.rows as? Set<CD_CT_Row> else { return }
        
        for cdRow in cdRows {
            
            guard let cdCells = cdRow.cells as? Set<CD_CT_Cell> else { return }
            
            for cdc in cdCells {
                
                guard let rowNumId = cdRow.rowId,
                    let cellNumId = cdc.cId else {return}
                
                let rowId = Int.init(truncating: rowNumId)
                let cId = Int.init(truncating: cellNumId)
                
                guard let newVal = totem.get_O(rowId: rowId, cellId: cId) else { return }
                
                cdc.o = NSNumber.init(value: newVal)
            }
            
        }
        
    }
        
    
    
    
    // MARK:- Privates
    
    private func updateStickerTotemLocalVars(record: CD_CT_Sticker, sticker: CrackTotemSticker) {
        
        record.name = sticker.name
        record.sid = NSNumber.init(value: sticker.sid)
        record.numOfRows = NSNumber.init(value: sticker.numOfRows)
        record.sort = NSNumber.init(value: sticker.sort)
        record.ver = NSNumber.init(value: sticker.ver)
        
        record.claimed = sticker.claimed
        record.count4Cripto = NSNumber.init(value: sticker.count4Cripto)
        
    }
    
    private func getEarnedAndRequiredTaps(cdtSticker: CD_CT_Sticker) -> (earned: Int, required: Int) {
        
        guard let readClaimed = cdtSticker.count4Cripto,
            let claimed = Int.init(exactly: readClaimed) else { return (0, 0) }
        
        let earned = sumAllTapsThroughCellsIn(cdtSticker: cdtSticker)
        
        return (earned, claimed)
        
    }
    
    // nemam informaciju na samom sticker-u, nego prolazim kroz sve rows pa kroz sve cells da bih sumirao vrednosti u: 'o'
    
    private func sumAllTapsThroughCellsIn(cdtSticker: CD_CT_Sticker) -> Int {
        
        var allCellsAtTotemSticker = [CD_CT_Cell]()
        
        let rows: [CD_CT_Row] = Array.init(cdtSticker.rows) as! [CD_CT_Row]

        for r in rows {
            
            let cells: [CD_CT_Cell] = Array.init(r.cells) as! [CD_CT_Cell]
            
            allCellsAtTotemSticker = allCellsAtTotemSticker + cells
            
        }
        
        let earned = allCellsAtTotemSticker.reduce(0) { (res, cell) -> Int in
            if let o = cell.o {
                return res + Int(truncating: o)
            }
            return 0 // fallback
        }
        
        print("sumAllTapsThroughCellsIn.earned = \(earned)")
        return earned
        
    }
    
    
    
//    private func updateRecordOwnProperties(record: CD_CT_Sticker, sticker: CrackTotemSticker) {
//
//        record.name = sticker.name
//        record.sid = NSNumber.init(value: sticker.sid)
//        record.numOfRows = NSNumber.init(value: sticker.numOfRows)
//        record.sort = NSNumber.init(value: sticker.sort)
//        record.ver = NSNumber.init(value: sticker.ver)
//
//        record.claimed = sticker.claimed
//        record.count4Cripto = NSNumber.init(value: sticker.count4Cripto)
//
//    }
    
}
