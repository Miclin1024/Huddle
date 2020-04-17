//
//  HuddleDetailVC.swift
//  Huddle
//
//  Created by Nicholas Wang on 4/17/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class HuddleDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var hostLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    
    var huddleName: String!
    var huddleHost: String!
    var huddleLoc: String!
    var huddleUsers: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = huddleName
        hostLbl.text = "Hosted by: \(String(describing: huddleHost))"
        locLbl.text = huddleLoc
        userLbl.text = "\(String(describing: huddleUsers)) users in this huddle"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinBtn(_ sender: Any) {
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
