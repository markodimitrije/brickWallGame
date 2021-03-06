//
//  CT_Protocols_1.swift
//  tryReadJsonFromBundle
//
//  Created by Marko Dimitrijevic on 07/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import CoreData

protocol BrickWallManaging {
    var totem: CrackTotemSticker? { get set }
    func userChoseTotemSid(_ sid: Int?)
    func recreateBrickWall(totem: CrackTotemSticker?)
    
}

extension BrickWallManaging {
    
    func userChoseTotemSid(_ sid: Int?) {
        print("BrickWallManaging.reportTotemSid: implement me")
    }
    
    func recreateBrickWall(totem: CrackTotemSticker?) {
        print("BrickWallManaging.recreateBrickWall: implement me")
    }
}

extension BrickWallVC: BrickWallManaging {
    
    var totem: CrackTotemSticker? {
        get {
            return _totem
        }
        set {
            _totem = newValue
        }
    }
    
    private func loadTotemFromJsonInBundle() {
        
        guard let filePath = Bundle.main.path(forResource: "totemTemp", ofType: "json"),
            let data = NSData(contentsOfFile: filePath) else {
                print("error. nemam resource")
                return
        }
        
        do { // here you have your json parsed as string:
            
            totem = try JSONDecoder().decode(CrackTotemSticker.self, from: data as Data)
            
        }
        catch { print("readBtnIsTapped.ERROR: cant parse jsonData") }
        
    }
    
    
    
    private func loadTotemFromCoreData(sid: Int?) {
        
        let req: NSFetchRequest<CDCrackTotem> = CDCrackTotem.fetchRequest()
        
        var cdTotem: CDCrackTotem?
        
        do {
            cdTotem = try context.fetch(req).first
        } catch {
            print("err, ne mogu da fetch from core data model")
        }
        
        guard let cts = cdTotem?.getCrackTotemSticker(sid: sid, ctx: context) else {
            print("loadTotemFromCoreData.err: nemam fetch iz CD modela"); return
        }
        
        totem = cts
        
    }
    
    
    
    
    private func getJsonPayloadForSyncWithWeb() -> [String: Any] {
        
        print("getJsonPayloadForSyncWithWeb is cALLED, implement me")
        return [:]
        
    }
    
    
    
    
    // MARK:-
    
    func userChoseTotemSid(_ sid: Int?) {
        
        guard let sid = sid else { return }
        
        loadTotemFromCoreData(sid: sid) // ali treba mi ovakav model
        
    }
    
    func recreateBrickWall(totem: CrackTotemSticker?) { // probaj sa Internal
        
        guard let totem = totem else { return }
        
        for row in totem.rows {
            
            recreateBrickRow(row: row, totem: totem)
            
        }
        
    }
    
    func recreateBrickRow(row: Row, totem: CrackTotemSticker) { // probaj sa Internal
        
        for cell in row.cells {
        
            let bi = SingleBrickInfo.init(numOfRows: totem.numOfRows, row: row, cell: cell)
            
            guard let v = self.createSingleBrick(brickInfo: bi, totalWallWidth: self.bricksWallView.bounds.width) else {
                return
            }
            
            self.bricksWallView?.addSubview(v)
            
        }
        
    }
    
}






protocol SingleBrickPresenting {
    func createSingleBrick(brickInfo: Any?, totalWallWidth: CGFloat) -> BW_BrickView?
    func updateSingleBrick(brickInfo: Any?)
    func getImageFor(brickPattern: BW_BrickPattern, index: Int?) -> UIImage?
    func getCrackIndex(o: Int, p: Int) -> Int?
}

extension SingleBrickPresenting {
    
    func createSingleBrick(brickInfo: Any?, totalWallWidth: CGFloat) -> BW_BrickView? {
        print("SingleBrickPresenting.createSingleBrick: implement me")
        return nil
    }
    
    func updateSingleBrick(brickInfo: Any?) {
        print("SingleBrickPresenting.updateSingleBrick: implement me")
    }
    
    func getImageFor(brickPattern: BW_BrickPattern, index: Int?) -> UIImage? {
        print("SingleBrickPresenting.getImageFor: implement me")
        return nil
    }
    
    func getCrackIndex(o: Int, p: Int) -> Int? {
        print("SingleBrickPresenting.getCrackIndex: implement me")
        return nil
    }
}

extension SingleBrickPresenting where Self: BrickWallVC {
    
    // MARK: - Privates
    
    private func getStartingAxisPos(row: Row, cellId: Int, bwTotalW: CGFloat) -> CGFloat {
        
        //let cellIds = row.cells.map {$0.cId}
        let beforeCells = row.cells.filter {$0.cId < cellId}
        let cellWidhts = beforeCells.map {CGFloat.init($0.w)/CGFloat.init(100)*SCREEN_WIDTH} // HC
        let totalWidth = cellWidhts.reduce(0){ $0 + $1 }
        return totalWidth
        
    }
    
    // MARK: - API
    
    func getCrackIndex(o: Int, p: Int) -> Int? {
        guard o < p else { return nil }
        // broj assets lx.png -> imam ih 8
        
        let level = Float.init(p) / Float.init(8) // recimo da ima 10 nivoa, mada ih i assets imam 7; +1 od 0 - no img
        let actual = Float.init(o) / level
        return Int.init(actual)
    }
    
    
    func getImageFor(brickPattern: BW_BrickPattern, index: Int?) -> UIImage? {
        
        guard let index = index, index >= 0 else { return nil }
        
        // .t: "c", .b: "b", .i: "l" - - - > 'c': Cigla, 'b': Bordura, 'l': Lomljeno
        let patternNames: [BW_BrickPattern: String] = [.t: "c", .b: "b", .i: "l"]
        
        let knownPatterns = patternNames.keys
        
        guard knownPatterns.contains(brickPattern) else { return nil }
        
        guard let imgBordureName = patternNames[brickPattern] else { return nil }
        
        return UIImage.init(named: imgBordureName + "\(index)")
        
    }
    
    
    func createSingleBrick(brickInfo: Any?, totalWallWidth: CGFloat) -> BW_BrickView? { // treba param inHostView: UIView
        
        guard let info = brickInfo as? SingleBrickInfo else { return nil }
        
        // calculate dimensions: size
        let rowHeight = self.bricksWallView.bounds.height / CGFloat.init(info.numOfRows)
        let cellWidthProcent = CGFloat.init(info.cell.w)
        let cellWidth = cellWidthProcent/100 * totalWallWidth
        
        // calculate dimensions: origin
        let yPos = CGFloat.init(info.row.rowId) * rowHeight
        let xPos = getStartingAxisPos(row: info.row, cellId: info.cell.cId, bwTotalW: self.bricksWallView.bounds.width)
        
        // calculate dimensions: frame
        let or = CGPoint.init(x: xPos, y: yPos)
        let size = CGSize.init(width: cellWidth, height: rowHeight)
        
        let frame = CGRect.init(origin: or, size: size)
        
        // create brick properties
        //let cellTxt = info.cell.txt // ovo je dodeli npr name Boby Charlton koje si dobio u data
        //let cellTxt = "\(info.cell.o)" + " / " + "\(info.cell.p)" // ovo je calculate: otk/uk za tu cell
        let cellTxt = "\(info.cell.p - info.cell.o)"
        let tImg = getImageFor(brickPattern: .t, index: info.cell.t)
        let bImg = getImageFor(brickPattern: .b, index: info.cell.b)
        
        let iImg = getImageFor(brickPattern: .i,
                               index: getCrackIndex(o: info.cell.o, p: info.cell.p))
        
        let brickView = BW_BrickView.init(cellId: info.cell.cId, frame: frame, bImg: bImg, tImg: tImg, iImg: iImg, txt: cellTxt)
        
        brickView.delegate = self
        
        brickView.isHidden = (info.cell.o == info.cell.p) // otkucane do kraja, ne prikazuj
        
        return brickView
     
    }
    
    func updateSingleBrick(brickInfo: Any?) {
        
        guard let info = brickInfo as? SingleBrickInfo else { return }
        
        // implement me
        
    }
    
    
}


//getTapValue(hammerActive: hammerActive)

protocol BrickTapResponsing: class {
    func brickTappedAt(cellId: Int?)
    func isHammerActive() -> Bool
    func getTapValue(hammerActive: Bool) -> Int
}

extension BrickTapResponsing {
    func brickTappedAt(cellId: Int?) {
        print("BrickTapReporting.brickTappedAt: implement me")
    }
    func getTapValue(hammerActive: Bool) -> Int {
        print("BrickTapReporting.getTapValue: implement me")
        return 1
    }
    func isHammerActive() -> Bool {
        print("BrickTapReporting.isHammerActive: implement me")
        return false
    }
}

extension BrickTapResponsing where Self: BrickWallVC {
    
    private func updateLocalModel(cellId: Int, value: Int) -> Cell? { // updateActualTotemData

        let cell = totem?.updateCell(withCellId: cellId, newTaps: value) // update LOCAL VAR (mem, heap)
        
        return cell
        
    }
    
    func getCounterText() -> String {
        
        let txt = tm.getCounterValue() ?? ""
        return txt
    }
    
    func isHammerActive() -> Bool {
        
        return tm.isUserUsingHammer() // OK
        
    }
    
    func getTapValue(hammerActive: Bool) -> Int {

        return ( hammerActive ) ? CT_BRICK_TAP_VAL_GAIN : CT_BRICK_TAP_VAL_REG

    }
    
    func brickTappedAt(cellId: Int?) {
        
        modelStateIsChanged()
        
        guard let cellId = cellId else {
            print("BrickTapReporting.BrickWallVC.brickTappedAt.ERROR: NISAM DOBIO REF"); return
        }
        
        let value = getTapValue(hammerActive: isHammerActive())
        
        // updateActualTotemData - update LOCAL VAR and get back SYNCED DATA
        guard let cell = updateLocalModel(cellId: cellId, value: value) else {
            print("BrickTapReporting.BrickWallVC.brickTappedAt.ERROR: NEMAM UPDATED DATA")
            return
        }
        
        let selectedView = self.bricksWallView.subviews.first(where: { (sv) -> Bool in
            guard let sv = sv as? BW_BrickView else { return false }
            return sv.cellId == cellId
        })
        
        guard let brickView = selectedView as? BW_BrickView else { return }
        
//        print("cell.o = \(cell.o)")
//        print("cell.p = \(cell.p)")
        
        brickView.isHidden = (cell.o >= cell.p) // logicno je == ali moze da koristi i hammer (.o by 5)
        
        let crackIndex = getCrackIndex(o: cell.o, p: cell.p)
        
        let img = getImageFor(brickPattern: .i, index: crackIndex)
        
        brickView.updateBrick(otk: cell.o, total: cell.p, img: img)
        
        bwBarView.updateBricksBarView(totem: totem)
        
        //makeIphoneVibrate() probati za > iphone 7
        
        modelStateIsChanged()
        
    }
}
