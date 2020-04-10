//
//  HuddleSearchBtn.swift
//  Huddle
//
//  Created by Michael Lin on 4/10/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class HuddleSearchBtn: UIButton {
    
    var gradientLayer: CAGradientLayer!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor(hex: "#5574f7").cgColor, UIColor(hex: "#60c3ff").cgColor]
        self.layer.addSublayer(gradientLayer)
    }
}
