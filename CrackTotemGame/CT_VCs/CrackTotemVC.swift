////
////  CrackTotemVC.swift
////  StickersApp
////
////  Created by Marko Dimitrijevic on 01/03/2018.
////  Copyright © 2018 Dragan Krtalic. All rights reserved.
////
//
//import UIKit
//
//class CrackTotemVC: GameController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        gameHasBegun()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        game = nil
//    }
//
//    // dodaj igri oponenta, da te drugi ne prekidaju...
//    private func gameHasBegun() {
//
//        guard let meEmail = intermediateForUser.actualUser?.email else { return }
//        game?.addOponentWith(meEmail)
//    }
//
//}

