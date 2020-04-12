//
//  HuddlePanelVC.swift
//  Huddle
//
//  Created by Nicholas Wang on 4/11/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Spring
import GoogleMaps
import FloatingPanel
import Haptica
import Firebase

// MARK: HuddlePanelVC
class HuddlePanelVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var huddleList: [Huddle]!               // HAS ALL HUDDLES FROM FIREBASE - NICK
    
    override func viewDidLoad() {
        setupList()
    }
    
    func setupList() {
        huddleList = []
        let ref = Database.database().reference()
        let userRef = ref.child("Huddles")
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let usersDict = snapshot.value as? [String: [String: Any]] else {
                print("Huddle Error")
                return
            }
            for (huddleHash, _) in usersDict {
                guard let userInfoDict = usersDict[huddleHash] else {
                    print("Huddle Error 2")
                    return
                }
                let name: String = userInfoDict["name"] as! String
                let desc: String = userInfoDict["description"] as! String
                let lat: Double = userInfoDict["lat"] as! Double
                let long: Double = userInfoDict["long"] as! Double
                let cur_huddle = Huddle(withLocation: CLLocation(latitude: lat, longitude: long), name: name, description: desc)
                self.huddleList.append(cur_huddle)
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func createHuddle(_ sender: Any) {
        Haptic.impact(.rigid).generate()
        
    }
}

extension HuddlePanelVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return huddleList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "huddleEntry") as! HuddleEntryCell
        cell.huddleNameLbl.text = huddleList[index].name
        cell.huddleDescLbl.text = huddleList[index].description
        cell.usersCountLbl.text = "\(huddleList[index].participants.count) students present"
        return cell
    }
    
    
}
