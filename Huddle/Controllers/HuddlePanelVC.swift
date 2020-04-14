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
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var panelBlurEffect: UIVisualEffectView!
    
    var huddleList: [Huddle] = []
    
    override func viewDidLoad() {
        setupTableViewUpdate()
        
        let storage = Storage.storage()
        
        userProfile.layer.cornerRadius = 10
        let userProfileStorageRef = storage.reference().child("userProfile/Miclin.jpg")
        userProfileStorageRef.getData(maxSize: 1 * 1024 * 1024, completion: { data, error in
            if let error = error {
                NSLog("Error reading from firebase: \(error)")
            } else {
                self.userProfile.image = UIImage(data: data!)
            }
        })
    }
    
    func setupTableViewUpdate() {
        let callback = { (huddleList: [Huddle]) in
            self.huddleList = huddleList
            self.tableView.reloadData()
        }
        Manager.shared.setupHuddleUpdate(completionHandler: callback)
    }
    
    @IBAction func createHuddle(_ sender: Any) {
        Haptic.impact(.rigid).generate()
        
    }
}

extension HuddlePanelVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HuddlePanelVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return huddleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "huddleEntry") as! HuddleEntryCell
        cell.huddleNameLbl.text = huddleList[index].name.uppercased()
        cell.huddleDescLbl.text = huddleList[index].description
        cell.usersCountLbl.text = String(huddleList[index].users.count)
        return cell
    }
}
