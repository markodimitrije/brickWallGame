////
////  CT_Game_Protocols_1.swift
////  StickersApp
////
////  Created by Marko Dimitrijevic on 01/03/2018.
////  Copyright © 2018 Dragan Krtalic. All rights reserved.
////
//
//import Foundation
//
//protocol GameHandlingWithCrackTotemHandling: GameHandling {
//
//    func openCrackTotemVC()
//    func crackGameWantsToBegin() // pritisnuo je ili cell na VC sa cells ili cell u albumStream-u
//    func displayTotemsForCracking() // prikazi kontroler sa cells koje su tipa: CrackTotemCell
//
//}
//
//extension GameHandlingWithCrackTotemHandling {
//
//    func openCrackTotemVC() {
//        print("openCrackTotemVC.implement me if selected from albumStreamVC")
//    }
//
//    func crackGameWantsToBegin() {
//        print("crackGameWantsToBegin.implement me if selected from albumStreamVC")
//    }
//
//    func displayTotemsForCracking() {
//        print("displayTotemsForCracking.implement me if selected from gamesCVC")
//    }
//
//}
//
//extension GameHandlingWithCrackTotemHandling where Self: MainViewController {
//
//    func displayTotemsForCracking() { // samo ovu func implementiram, ostale su default
//
//        guard let gctVC = gamesStoryboard.instantiateViewController(withIdentifier: "CrackingTotemsVC") as? CrackingTotemsVC else { return }
//
//        // HOOK UP ANY DELEGATE ??
//
//        self.navigationController?.pushViewController(gctVC, animated: true)
//
//    }
//
//}
//
//extension GameHandlingWithCrackTotemHandling where Self: AlbumStreamVC {
//
//    func displayTotemsForCracking() { // samo ovu func implementiram, ostale su default
//
//        guard let gctVC = gamesStoryboard.instantiateViewController(withIdentifier: "CrackTotemVC") as? CrackTotemVC else {
//            return
//        }
//
//        // HOOK UP ANY DELEGATE ??
//
//        self.navigationController?.pushViewController(gctVC, animated: true)
//
//    }
//
//    func crackGameWantsToBegin() {
//
//        let gameCenter = GameCenter()
//
//        gameCenter.gameStarts(game)
//
//    }
//
//    func openCrackTotemVC() {
//
//        print("GameHandlingWithCrackTotemHandling.AlbumStreamVC.openCrackTotemVC.otvori mu game VC")
//        self.performSegue(withIdentifier: "segueShowCrackTotemVC", sender: self)
//
//    }
//
//}

