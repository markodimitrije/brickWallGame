//
//  CT_Networking.swift
//  StickersApp
//
//  Created by Marko Dimitrijevic on 02/03/2018.
//  Copyright © 2018 Dragan Krtalic. All rights reserved.
//

import Foundation

class CrackTotemRequestManager {
    
    func getAllCrests(token: String?, successHandler: @escaping(_ jSON: Data?) -> Void) {
        
        CT_ServerRequest().getAllCrests(token: token) { (allTotems) in
            
//            print("CrackTotemRequestManager.getAllCrests.allTotems = \(String(describing: allTotems))")
            
            if allTotems == nil { // server down ili ima neka greska
                
//                connection.hasServerConnection = false // postavi notifIcon
                
            } else { // success == true
                
//                connection.hasServerConnection = true // ukloni notifIcon ako je postavljen
                
            }
            
            successHandler(allTotems)
            
        }
        
    }
    
    
    func getAllCrestsFromBundle(token: String?, successHandler: @escaping(_ jSON: Data?) -> Void) {
        
        guard let url = Bundle.main.url(forResource: "allCrests", withExtension: "json") else {
            print("getAllCrestsFromBundle.nemam json resource u bundle")
            return
        }
        var data: Data?
        do {
            data = try Data.init(contentsOf: url)
        } catch {
            print("getAllCrestsFromBundle.nemam json resource u bundle")
        }
        
//        print("getAllCrestsFromBundle.data = \(data)")
        
        successHandler(data)
        
    }
    
  
    
}
