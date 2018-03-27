//
//  CT_Protocols_2.swift
//  tryReadJsonFromBundle
//
//  Created by Marko Dimitrijevic on 12/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

protocol BrickBarManaging: class {
    func getCoinTypeForBuyingTotem() -> CoinType
    func gameIsFinished()
}

extension BrickBarManaging {
    func getCoinTypeForBuyingTotem() -> CoinType {
        print("BrickBarManaging.getCoinTypeForBuyingTotem/ implement me")
        return CoinType.gold
    }
    func gameIsFinished() {
        print("BrickBarManaging.gameIsFinished/ implement me")
    }
}




protocol TriangleShapedShadowDroping {
    func dropDiagShadow(inView v: UIView, insetValuePercent value: CGFloat, shadowColor: UIColor)
}

extension TriangleShapedShadowDroping {
    func dropDiagShadow(inView v: UIView, insetValuePercent value: CGFloat = 10.0, shadowColor: UIColor = .black) {
        
        let path = getLowerTrianglePathWithInsetFor(rect: v.bounds, insetValuePercent: value)
        let pathLayer = CAShapeLayer()
        
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = shadowColor.cgColor
        pathLayer.lineWidth = 0
        pathLayer.fillColor = shadowColor.cgColor
        
        v.layer.addSublayer(pathLayer)

    }
    
    private func getLowerTrianglePathWithInsetFor(rect: CGRect, insetValuePercent value: CGFloat = 10) -> UIBezierPath {
        
        let p = UIBezierPath.init()
        
        let in_w = rect.width * value / 100
        let in_h = rect.height * value / 100
        
        let topRightPt = CGPoint.init(x: rect.maxX, y: rect.minY + in_h)
        let lowLeftPt = CGPoint.init(x: rect.minX + in_w, y: rect.maxY)
        let lowRightPt = CGPoint.init(x: rect.maxX, y: rect.maxY)
        p.move(to: topRightPt)
        p.addLine(to: lowLeftPt)
        p.addLine(to: lowRightPt)
        p.close()
        
        return p
        
    }
}



protocol BtnTapManaging: class {
    func btnTapped(sender: UIButton)
}

protocol BuyTotemAndHammerBtnTapManaging: BtnTapManaging {
    func isHammerAvailable() -> Bool?
}



extension BtnTapManaging {
    func btnTapped(sender: UIButton) {
        print("BtnTapManaging.btnTapped: implement me")
    }
}

extension BtnTapManaging where Self: BrickWallVC {
    func btnTapped(sender: UIButton) {
        print("BtnTapManaging.btnTapped: sender.tag = \(sender.tag)")
    }
}

extension BuyTotemAndHammerBtnTapManaging {
    func isHammerAvailable() -> Bool? {
        print("HammerBtnTapManaging.isHammerAvailable: implement me")
        return false
    }
}

extension BuyTotemAndHammerBtnTapManaging where Self: BrickWallVC {
    
    func isHammerAvailable() -> Bool? {
        
        if let claimedAt = ud.value(forKey: CT_UD_KEY_USER_CLAIMED_HAMMER_AT) as? Date { // ako imas
            return tm.now.timeIntervalSince(claimedAt) > tm.timeToWaitAndUseHammer
        }
        
        guard let counter = tm.getTimerValue() else { return nil }
        
        return (counter == -1) || (counter < 0)// ako je neg value, hammer je available
        
    }
    
    func btnTapped(sender: UIButton) {
        
        switch sender.tag {
            
        case 0: userTappedBuyTotemBtn() // znam sa storyboard-a da je ovo buyTotemBtn
            
        case 1: userTappedHammerBtn() // znam sa storyboard-a da je ovo hammerBtn
            
        case 20: userTappedGameOverView()
            
        default: break
        }
        
    }
    
    // MARK:- Private - process na btn tapped:
    
    private func userTappedHammerBtn() {
        
        guard let isHammerAvailable = isHammerAvailable() else { return }
        
        if isHammerAvailable {
            
            tm.userSuccessfullyClaimedHammer()

        }
        
    }
    
    private func userTappedBuyTotemBtn() {
        
        print("userTappedBuyTotemBtn.prikazi alert sa bice ova funkc u sled release")
        
    }
    
    private func userTappedGameOverView() {
        
        bwGameOverView.isHidden = true
        
    }
    
}






protocol HammerViewCounterFormating {
    func getFormatedCounter(forValue value: Int) -> String
}

extension HammerViewCounterFormating {
    func getFormatedCounter(forValue value: Int) -> String {
        print("getFormatedCounter.implement me")
        return "\(value)"
    }
}



protocol SaveToModelManaging: class {
    func appIsGoingToBg()
}

protocol CrackTotemSaveStateManaging: SaveToModelManaging {
    func modelStateIsChanged()
}


extension SaveToModelManaging {
    func appIsGoingToBg() {
        print("SaveToModelManaging.appIsGoingToBg: implement me")
    }
    func userQuitGame() {
        print("SaveToModelManaging.userQuitGame: implement me")
    }
}

extension CrackTotemSaveStateManaging {
    func modelStateIsChanged() {
        print("SaveToModelManaging.modelStateIsChanged: implement me")
    }
}

extension CrackTotemSaveStateManaging where Self: BrickWallVC {
    
    private func saveStateImidiatelly() {
        
        let bgc = appDel.persistentContainer.newBackgroundContext()
        
        bgc.performAndWait {
        
            let freq: NSFetchRequest<CDCrackTotem> = CDCrackTotem.fetchRequest()
            var cts: CDCrackTotem?
            do {
                let structures = try bgc.fetch(freq)
                cts = structures.first
            } catch {
                print("saveStateImidiatelly.catch nisam prosao fetch za CTS")
            }
            
            cts?.updateStickerTotemToCoreData(totem: self.totem, ctx: bgc)
            
        }
        
        tryToSaveInContext(ctx: bgc)
        
    }
    
    
    func userQuitGame() {
        
        saveStateImidiatelly()
        
        self.gameIsBecomingInactive() // ima preko protocol_2 -> javi web-u
    }
    
    func appIsGoingToBg() {
        print("CrackTotemSaveStateManaging.appIsGoingToBg is CALLED")
        saveStateImidiatelly()
        
        self.gameIsBecomingInactive() // javi web-u
    }
    
    func modelStateIsChanged() {
        
        guard let totalScore = totem?.getScore() else { return }
        
        if totalScore % CT_SAVE_STATE_EVERY_IN_TAPS == 0 {
//            print(" % 100 je ispunjen, zovi SAVE U CORE DATA")
            saveStateImidiatelly()
        }
        
    }
    
}



protocol GameStateToWebReporting {
    func gameIsBecomingInactive()
    func userEnterTheGame()
}

extension GameStateToWebReporting {
    func gameIsBecomingInactive() {
        print("SyncGameStateWithWebManaging/gameIsBecomingInactive is CALLED")
    }
    func userEnterTheGame() {
        print("SyncGameStateWithWebManaging/userEnterTheGame is CALLED")
    }
}

protocol CrackTotemGameWebReporting: GameStateToWebReporting {
    func getPayloadToReport(totem: CrackTotemSticker?) -> [String: Any]
}

extension CrackTotemGameWebReporting where Self: BrickWallVC {
    
    private func getControlStr() -> String? { // implement me...
        
        guard let total_P = totem?.getTotal_P(),
            let total_O = totem?.getTotal_O() else { return nil }
        
        let input = CT_GAME_SECURE_KEY + "\(total_O - total_P)"
        
        //let digest = input.md5
        
        let digest = input
        
//        print("getControlStr.md5: \(String(describing: digest))")
        
        //return "ecab33a1548b3da2d101b498f039fbb6"
        
        return digest
        
    }
    
    private func getTotemAsJson(sid: Int?) -> [String: Any]? { // implement me codable....
        
        //guard let sid = sid, let totemAsJson = totem?.sid else { return nil }
        
        guard let json = totem?.jsonRepresentation else { return nil }
        
        return json
        
    }
    
    private func getPayloadFor(sid: Int?) -> [String: Any]? {
        
        guard let sid = sid,
            let totemData = getTotemAsJson(sid: sid),
            let controlStr = getControlStr()
        else { return nil }
        
        return ["token": token, "controlStr": controlStr, "stickerData": totemData ]
        
    }
    
    private func reportToWeb(payload: [String: Any]) {
        print("CrackTotemGameWebReporting.BrickWallVC/reportToWeb - implement me")
    }
    
    func getPayloadToReport(totem: CrackTotemSticker?) -> [String: Any] {
        print("CrackTotemGameWebReporting.BrickWallVC/getPayloadToReport - implement me")
        return [:]
    }
    
    func gameIsBecomingInactive() {
        
        guard let payload = getPayloadFor(sid: totem?.sid) else { return }
        
        CT_NetworkingAndCoreDataManager().updateCrestToWeb(payload: payload) { (success) in
            if let success = success, success {
                print("updateCrestToWeb.gameIsBecomingInactive.successfully reported to web")
            } else {
                print("updateCrestToWeb.gameIsBecomingInactive.nije uspeo da update-uje....")
            }
        }
        
    }
    func userEnterTheGame() {
        print("SyncGameStateWithWebManaging/userEnterTheGame is CALLED")
        //procitaj svoj totem, prepakuj u jSON i javi web-u
    }
}













func tryToSaveInContext(ctx: NSManagedObjectContext) {
    
    do {
        try ctx.save()
//        print("tryToSaveInContext/sacuvao sam na zadatom context-u . .. . ")
    } catch {
        print("tryToSaveInContext/catch.nisam uspeo da sacuvam...")
    }
    
}
