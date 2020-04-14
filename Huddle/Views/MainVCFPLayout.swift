//
//  MainVCFPLayout.swift
//  Huddle
//
//  Created by Michael Lin on 4/9/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation
import FloatingPanel

class MainVCFPLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .half
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full: return 120.0 // A top inset from safe area
            case .half: return 340.0 // A bottom inset from the safe area
            case .tip: return 80.0 // A bottom inset from the safe area
            default: return nil // Or `case .hidden: return nil`
        }
    }
}
