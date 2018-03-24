//
//  CT_Game_Protocols_2.swift
//  StickersApp
//
//  Created by Marko Dimitrijevic on 02/03/2018.
//  Copyright © 2018 Dragan Krtalic. All rights reserved.
//

import Foundation

protocol CrackTotemWebDataManaging {
    //func getAllCrest() -> CrackTotemStructure
    func getAllCrestsFromWeb(successHandler: @escaping (_ data: CrackTotemStructure?) -> Void)
    func getCrestFromWeb(sid: Int) -> CrackTotemSticker?
    func updateCrestToWeb(payload: [String: Any]?, completionHandler: @escaping (_ success: Bool?)->Void)
}

protocol CrackTotemInternalDataManaging { // CoreData
    func saveAllCrestsResponseToCDCrackTotem(data: CrackTotemStructure) // all data response
    func updateCrestResponseToCDCrackTotem(data: CrackTotemSticker) // server response
    func updateCrestDataToCDCrackTotem(data: CrackTotemSticker) // user tapkao
}
