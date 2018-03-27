//
//  BrickWallVC.swift
//  tryReadJsonFromBundle
//
//  Created by Marko Dimitrijevic on 07/03/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import QuartzCore

class BrickWallVC: UIViewController {

    var _totem: CrackTotemSticker? {
        didSet {
            guard let totem = _totem else { return }
//            recreateBrickWall(totem: totem) // by protocol
        }
    }
    
    var timer: Timer?
    let tm = BW_TimerManager()
    
    @IBOutlet weak var bwBarView: BB_BricksBarView!
    
    @IBOutlet weak var totemImgView: UIImageView!
    
    @IBOutlet weak var bricksWallView: UIView!
    
    @IBOutlet weak var barInfoToSafeAreaCnstr: NSLayoutConstraint!
    
    @IBOutlet weak var hideBarInfoViewCnstr: NSLayoutConstraint!
    
    @IBOutlet weak var bwGameOverView: BW_GameOver!
    
    override func viewDidLoad() { super.viewDidLoad()
        
        super.viewDidLoad()
        
        attachDelegates()
        
        tm.recreateState(timer: &timer) // ovo ce da napuni VALUE odakle citas
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.userQuitGame() // ima iz ex. BrickWallVC: CrackTotemSaveStateManaging {} // protocols_2
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        tm.saveState()
        
        timer?.invalidate(); timer = nil
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        recreateBrickWall(totem: _totem) // by protocol
        
        loadTotemImgView(totem: _totem)
        
        loadBricksBarView(totem: _totem)
        
        bricksWallView.backgroundColor = .clear // na SB sam set na neku drugu jer se video transitioning
        
        hookUpDelegateToBarComponents()
        
        tm.viewDidAppear()
        
    }
    
    func getCellFromActualTotem(forCellId cellId: Int?) -> Cell? {
        guard let cellId = cellId, let totem = totem else { return nil }
        let rows = totem.rows
        let cellsByCellId = rows.map {$0.cells}.joined()
        let cells = cellsByCellId.filter {$0.cId == cellId}
        
        guard !cells.isEmpty, let cell = cells.first else {
            print("getCellFromActualTotem.ERROR, nisam nasao cell za dati CellId")
            return nil
        }
        
        return cell
    }
    
    private func attachDelegates() {
        
        tm.delegate = self
        
        bwGameOverView.delegate = self
        
        bwBarView.delegate = self // javice mi kada je score == 0
        
    }
    
    private func hookUpDelegateToBarComponents() { // process od didLoad
        
        for sv in bwBarView.subviews.first!.subviews.first!.subviews {
            if let hv = sv as? BB_HammerView {
                hv.delegate = self
            }
            if let btv = sv as? BB_BuyTotemView {
                btv.delegate = self
            }
        }
        
    }
    
    private func loadTotemImgView(totem: CrackTotemSticker?) {
        
        guard let totem = totem else { return }
        
        let totalSid = totem.sid // u ORIGINAL app imam method koji dovlaci sliku iz CD
        
        totemImgView.image = UIImage.init(named: "ronaldo") // HC
    
    }
    
    private func loadBricksBarView(totem: CrackTotemSticker?) {
        
        func dropShadows() {
            
            self.dropDiagShadow(inView: bwBarView.buyTotemView.shadeView, insetValuePercent: 10, shadowColor: .green)
            
            self.dropDiagShadow(inView: bwBarView.hammerView.shadeView, insetValuePercent: 10, shadowColor: .green)
        }
        
        guard let totem = totem else { return }
        
        guard totem.getScore() > 0 else { // ako je zavrsio ovaj totem ( == 0 )
            //gameIsFinished() // prikazi mu view, da je vec zaradio ovaj sticker
            translateBarInfoViewBelowNavBar() // prikazi mu view, da ima ovaj sticker
            return // izadji...
        }
        
        let hammerActive = isHammerActive()
        
        let counterText = getCounterText()
        
        bwBarView.updateBricksBarView(totem: totem, coinType: .gold, hammerActive: hammerActive, counterTime: counterText)
        
         dropShadows() // postavi shadows na buyTotemView i hammerView - - HC TEMP OFF
        
    }
    
    @objc func updateClock() {
        
        guard let val = tm.getCounterValue() else { print("error reading from TimeManager"); return }
            
//        print("updateClock.val = \(val)")
        
        updateUI(countVal: val, hammerIsActive: isHammerActive(), hammerIsAvailable: isHammerAvailable() ?? false) // HC !
    
    }
    
    private func updateUI(countVal: String, hammerIsActive: Bool, hammerIsAvailable: Bool) {
        
        let hammerOn = (hammerIsActive || hammerIsAvailable)
        
        let hammerImg = hammerOn ? #imageLiteral(resourceName: "hammer_ON") : #imageLiteral(resourceName: "hammer_OFF")
        
        let clockImg: UIImage? = (countVal == CT_USE_HAMMER) ? nil : (hammerIsActive) ? #imageLiteral(resourceName: "hammer_ON") : #imageLiteral(resourceName: "stopwatch")
        
        let lblTxtColor: UIColor = hammerOn ? .white : .gray
        
        bwBarView.hammerView.updateView(imgFirst: hammerImg, imgSecond: clockImg, text: countVal, lblTxtColor: lblTxtColor)
    }
    
    // MARK:- respond to gameOver msg
    
    fileprivate func showGameOverInfoView() {

        bwGameOverView.isHidden = false
    }
    
    fileprivate func translateBarInfoViewBelowNavBar() {
        
        bwBarView.stackTopToSafeAreaTopCnstr.isActive = false // iz nekog razloga moram da ugasim nesto od height constraint-a na njegovom stack-u ?!?
        barInfoToSafeAreaCnstr.isActive = false
        hideBarInfoViewCnstr.isActive = true
        
    }
    
}

extension BrickWallVC: SingleBrickPresenting {} // mora da zna da prikaze ciglu

extension BrickWallVC: BrickTapResponsing {} // i da reaguje na Tap koji mu cigla javi

extension BrickWallVC: TriangleShapedShadowDroping {} // protocols_2

extension BrickWallVC: BuyTotemAndHammerBtnTapManaging {} // protocols_2

extension BrickWallVC: BrickBarManaging {} // protocols_2


extension BrickBarManaging where Self: BrickWallVC {
    
    // sakrij barInfoView ispod navBar-a
    // prikazi gameOverInfoView
    func gameIsFinished() {
        
        showGameOverInfoView()
        
        translateBarInfoViewBelowNavBar()
        
    }
}

extension BrickWallVC: CrackTotemSaveStateManaging {} // protocols_2

extension BrickWallVC: CrackTotemGameWebReporting {} // protocols_2
