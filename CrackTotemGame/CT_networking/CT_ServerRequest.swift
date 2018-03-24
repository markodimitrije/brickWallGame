//
//  CT_ServerRequest.swift
//  StickersApp
//
//  Created by Marko Dimitrijevic on 02/03/2018.
//  Copyright © 2018 Dragan Krtalic. All rights reserved.
//

import Foundation

class CT_ServerRequest {
    
    func getAllCrests(token: String?, successHandler: @escaping (_ jSON: Data?) -> Void) {
        
        guard let token = token else { return }
        
        let domain = STICKER_DOMAIN_NAME
        
        let command = "games/crest/getAllCrest?"
        
        let paramString = "token=\(token)"
        
        let finalUrlString: String = domain + command + paramString
        
        //        print("CT_ServerRequest.getAllCrests.finalUrlString = \(finalUrlString)")
        
        let url = URL(string: finalUrlString)
        
        let request = NSMutableURLRequest(url: url!)
        
        request.timeoutInterval = 10.0
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            
            (data, response, error) -> Void in
            
            guard error == nil, let data = data, let response = response as? HTTPURLResponse else {
                
                    successHandler(nil) // imas problem, vrati: nil
                    return
            }
            
//            print("CT_ServerRequest.getAllCrests.data = \(data)")
            
            if response.statusCode == 200 {
            
                successHandler(data)
                
            } else {
                
                successHandler(nil)
                
            }
            
        })
        
        task.resume()
        
    }

    
    
    
    
    
    func updateCrestToWeb(payload: [String: Any], successHandler: @escaping (_ success: Bool?) -> Void) {
        
        let domain = STICKER_DOMAIN_NAME
        
        let command = "games/crest/updateCrest"
        
        let finalUrlString: String = domain + command
        
        print("CT_ServerRequest.updateCrest.finalUrlString = \(finalUrlString)")
        
        let request = NSMutableURLRequest(url: NSURL(string: finalUrlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        var data: Data?
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache"
        ]
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        do {
            data = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            print("updateCrestToWeb.catch: ne mogu da napravim payload as Data")
        }
        
        guard let postData = data else { return }
        
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                successHandler(nil)
            } else {
                let httpResponse = response as? HTTPURLResponse
                successHandler(httpResponse?.statusCode == 200 )
            }
        })
        
        dataTask.resume()
        
    }
    
}
