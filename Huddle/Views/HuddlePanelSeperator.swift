//
//  HuddlePanelSeperator.swift
//  Huddle
//
//  Created by Michael Lin on 4/10/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class HuddlePanelSeparator: UIView {
    
    let lineWidth: CGFloat = 2.0

    override func draw(_ rect: CGRect) {
        let hr = UIBezierPath()
        hr.move(to: CGPoint(x: 0, y: 4))
        hr.addLine(to: CGPoint(x: bounds.width, y: 4))
        UIColor(hex: "#e2e8ed").setStroke()
        hr.lineWidth = lineWidth
        hr.stroke()
    }
}
