//
//  MainTabBar.swift
//  Huddle
//
//  Created by Michael Lin on 4/14/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class MainTabBar: UITabBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {

    }
}
