//
//  CT_NetworkingAndCoreDataManaging.swift
//  StickersApp
//
//  Created by Marko Dimitrijevic on 02/03/2018.
//  Copyright © 2018 Dragan Krtalic. All rights reserved.
//

import UIKit
import CoreData
//import AERecord

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

struct CT_NetworkingAndCoreDataManager: CrackTotemWebDataManaging, CrackTotemInternalDataManaging {
    
    // MARK: - WEB DATA SYNC
    
    func getAllCrestsFromWeb(successHandler: @escaping (_ data: CrackTotemStructure?) -> Void) {

        CrackTotemRequestManager().getAllCrests(token: token) { (data) in

            guard let data = data else { return }

            do {
                let cts = try JSONDecoder().decode(CrackTotemStructure.self, from: data)
                
                successHandler(cts)
                
            } catch { // err
//                    print("CT_NetworkingAndCoreDataManager.getAllCrestFromWeb.catch ACTIVATED")
                successHandler(nil)
                
            }

        }

    }
    
    
    
    func getAllCrestsFromBundle(successHandler: @escaping (_ data: CrackTotemStructure?) -> Void) {
        
        CrackTotemRequestManager().getAllCrestsFromBundle(token: token) { (data) in
            
            guard let data = data else { return }
            
            do {
                let cts = try JSONDecoder().decode(CrackTotemStructure.self, from: data)
                
//                print("cts = \(cts)")
                
                successHandler(cts)
                
            } catch { // err
                //                    print("CT_NetworkingAndCoreDataManager.getAllCrestFromWeb.catch ACTIVATED")
                successHandler(nil)
                
            }
            
        }
        
    }
    
    
    
    //getAllCrestsFromBundle(token

    
    func getCrestFromWeb(sid: Int) -> CrackTotemSticker? {
        print("CT_NetworkingAndCoreDataManaging.getCrestFromWeb: nabavi 1 CREAT sa WEB-Aa")
        return nil
    }
    
    func updateCrestToWeb(payload: [String: Any]?, completionHandler: @escaping (_ success: Bool?) -> Void) {
    
        print("CT_NetworkingAndCoreDataManaging.updateCrestToWeb is CALLED")
        
        guard let payload = payload else { return }
        
        CT_ServerRequest().updateCrestToWeb(payload: payload) { (success) in
            completionHandler(success)
        }
        
    }
    
    // MARK: - CORE DATA SYNC
    
    func saveAllCrestsResponseToCDCrackTotem(data: CrackTotemStructure) {
        
        let bgCtx = appDel.persistentContainer.newBackgroundContext()
        
        bgCtx.performAndWait {
        
            self.saveAllDataStructure(data: data, ctx: bgCtx)

            ud.set(true, forKey: GAME_CRACK_TOTEM_DATA_DOWNLOADED_SUCCESSFULLY)
        
        }
        
        
    
    }
    
    
    
    
    
    
    
    
    
    func saveAllDataStructure(data: CrackTotemStructure, ctx: NSManagedObjectContext) {
        
//        print("saveAllDataStructure is CALLED !!")
        
        let cts = CDCrackTotem.init(entity: CDCrackTotem.entity(), insertInto: ctx)
        
//        print("saveAllDataStructure: PROSAO INIT OD CDCrackTotem !!")
        
        cts.tmplId = NSNumber.init(value: data.tmplId)
        cts.version = NSNumber.init(value: data.version)
        cts.numOfStk = NSNumber.init(value: data.numOfStk)
        cts.createdAt = data.created as NSDate
        cts.updatedAt = data.updated as NSDate
        cts.userId = data.userId
        
        cts.stickers = NSSet.init(set: cts.createAllTotemStickersFor(cts: data, ctx: ctx))
        
//        print("saveAllDataStructure: PROSAO UPDATE PROPERTIES !!")
        
        //appDel.saveContext()
        
        tryToSaveInContext(ctx: ctx)
        
//        print("saveAllDataStructure: PROSAO SAVE CONTEXT !!")
        
    }
    

    
    
    
//    func updateStickerInCoreData(totem: CrackTotemSticker?) {
//
//        let cts = CDCrackTotem.init(entity: CDCrackTotem.entity(), insertInto: context)
//
//        cts.updateStickerTotemToCoreData(totem: totem)
//
//    }
    
    
    
    
    
    
    
    
    
    
    func updateCrestResponseToCDCrackTotem(data: CrackTotemSticker) {
        
        print("CT_NetworkingAndCoreDataManaging.uptateCrest: SAVE 1 TO CORE_DATA")
        
    }
    func updateCrestDataToCDCrackTotem(data: CrackTotemSticker) {
        
        print("CT_NetworkingAndCoreDataManaging.updateCrestDataToCDCrackTotem: SAVE 1 ili vise koje je USER kuckao (na svakih N ili fg -> bg)")
        
    }
    
    
    
}
























// GLOBALS - NAPRAVI NEKI JSON PARSER HELPER BLA BLA













