//
//  Duplicate.swift
//  tryReadJsonFromBundle
//
//  Created by Marko Dimitrijevic on 07/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let ud = UserDefaults.standard

let token = "10155326821212777"

let STICKER_DOMAIN_NAME = "http://china.stickersbackend.co.uk:8080/stickers-prem/"

let sharedApp = UIApplication.shared.self

var appDel: AppDelegate! {
    
    return sharedApp.delegate as! AppDelegate
    
}






