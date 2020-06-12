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
import FirebaseStorage

// MARK: HuddlePanelVC
class HuddlePanelVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var panelBlurEffect: UIVisualEffectView!
    
    var huddleDetailVC: HuddleDetailVC!
    var addHuddleVC: AddHuddleVC!
    var huddleList: [Huddle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViewUpdate()
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = true
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
    }
    
    func setupTableViewUpdate() {
        let callback = { (huddleList: [Huddle]) in
            self.huddleList = huddleList
            self.tableView.reloadData()
        }
        Huddle.setupUpdate(updateCallback: callback)
    }
    
    @IBAction func createHuddle(_ sender: Any) {
        Haptic.impact(.rigid).generate()
        
        addHuddleVC = storyboard?.instantiateViewController(withIdentifier: "AddHuddle") as? AddHuddleVC
        addHuddleVC.modalPresentationStyle = .overCurrentContext
        self.present(addHuddleVC, animated: true, completion: nil)
    }
}

extension HuddlePanelVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let huddle = self.huddleList[indexPath.row]
        huddleDetailVC = storyboard?.instantiateViewController(withIdentifier: "HuddleDetail") as? HuddleDetailVC
        huddleDetailVC.modalPresentationStyle = .overCurrentContext
        huddleDetailVC.huddleName = huddle.name
        huddleDetailVC.huddleHost = huddle.host
        huddleDetailVC.huddleLoc = huddle.locationDescription
        huddleDetailVC.huddleUsers = huddle.users.count
        self.present(huddleDetailVC, animated: true, completion: nil)
    }
    
    
}

extension HuddlePanelVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return huddleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let huddle = self.huddleList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "huddleEntry") as! HuddleEntryCell
        cell.huddleNameLbl.text = huddle.name.uppercased()
        cell.huddleDescLbl.text = "\(huddle.description)   -   \(huddle.locationDescription)"
        cell.usersCountLbl.text = String(huddle.users.count)
        return cell
    }
}
