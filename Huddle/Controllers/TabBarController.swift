//
//  TabBarController.swift
//  Huddle
//
//  Created by Michael Lin on 4/25/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
//        tabBar.layer.borderWidth = 0
//        tabBar.layer.borderColor = UIColor.clear.cgColor
//        tabBar.clipsToBounds = true
        
        tabBar.isTranslucent = true
        
        
        let color = UIColor(hex: "#1e2228")
        tabBar.barTintColor = .clear
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        tabBar.backgroundColor = color
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
