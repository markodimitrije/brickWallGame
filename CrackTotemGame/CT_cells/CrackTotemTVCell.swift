////
////  CrackTotemCVCell.swift
////  StickersApp
////
////  Created by Marko Dimitrijevic on 01/03/2018.
////  Copyright © 2018 Dragan Krtalic. All rights reserved.
////
//
//import UIKit
//
//class CrackTotemTVCell: UITableViewCell {
//
//    @IBOutlet weak var imgView: UIImageView!
//
//    @IBOutlet weak var nameLbl: UILabel!
//
//    @IBOutlet weak var scoreLbl: UILabel!
//
//    var img: UIImage? {
//        get {
//            return imgView?.image
//        }
//        set {
//            imgView?.image = newValue
//        }
//    }
//
//    var totemName: String? {
//        get {
//            return nameLbl?.text
//        }
//        set {
//            nameLbl?.text = newValue
//        }
//    }
//
//    var score: String? {
//        get {
//            return scoreLbl?.text
//        }
//        set {
//            scoreLbl?.text = newValue
//        }
//    }
//
//    // MARK:- API
//    func updateCell(withInfo info: Totem) {
//
//        print("update cell data for info = \(info)")
//
//        img = CDSticker.stickerHRImageFor(info.sid)
//        totemName = info.name
//        score = "\(info.o)" + " / " + "\(abs(info.t))"
//
//    }
//
//}

