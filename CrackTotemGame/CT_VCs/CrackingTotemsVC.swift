////
////  CrackingTotemsVC.swift
////  StickersApp
////
////  Created by Marko Dimitrijevic on 01/03/2018.
////  Copyright © 2018 Dragan Krtalic. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class CrackingTotemsVC: UIViewController {
//
//
//    @IBOutlet weak var tableView: UITableView!
//
//    var data = [Totem]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //context.perform { -> ovo ne daje podatke u DATA !?!
//        context.performAndWait {
//
//            let cdCrackTotem = CDCrackTotem.init(entity: CDCrackTotem.entity(), insertInto: context)
//
//            print("stampam data.count = \(self.data.count)")
//
//            self.data = cdCrackTotem.getAllTotemStickersInfo().sorted(by: { $0.sort < $1.sort} )
//        }
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        game = nil
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//    }
//
//}
//
//extension CrackingTotemsVC: UITableViewDataSource, UITableViewDelegate {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("CrackingTotemsVC.numberOfRowsInSection.data.count = \(data.count)")
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "totemCell", for: indexPath) as? CrackTotemTVCell else {
//            print("vracam backUpCell")
//            return UITableViewCell.init()
//        }
//
//        configure(cell: cell, atIp: indexPath)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "segueShowCrackTotem", sender: self)
//    }
//
//    private func configure(cell: CrackTotemTVCell, atIp ip: IndexPath) {
//
//        let totemInfo = data[ip.row]
//
//        cell.updateCell(withInfo: totemInfo)
//
//    }
//
//}

