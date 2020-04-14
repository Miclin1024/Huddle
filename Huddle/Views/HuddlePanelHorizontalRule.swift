//
//  HuddlePanelHorizontalRule.swift
//  Huddle
//
//  Created by Michael Lin on 4/13/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class HuddlePanelHorizontalRule: UIView {

    let lineWidth: CGFloat = 3.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        tintColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let hr = UIBezierPath()
        hr.move(to: CGPoint(x: 0, y: 4))
        hr.addLine(to: CGPoint(x: bounds.width, y: 4))
        UIColor(hex: "#e2e8ed").setStroke()
        hr.lineWidth = lineWidth
        hr.stroke()
    }
}
