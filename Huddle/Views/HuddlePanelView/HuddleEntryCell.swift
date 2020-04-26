//
//  HuddleEntryCell.swift
//  Huddle
//
//  Created by Michael Lin on 4/9/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class HuddleEntryCell: UITableViewCell {

    @IBOutlet weak var huddleNameLbl: UILabel!
    @IBOutlet weak var huddleDescLbl: UILabel!
    @IBOutlet weak var usersCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        huddleDescLbl.textColor = UIColor(white: 0.7, alpha: 1)
        huddleNameLbl.textColor = .white
        usersCountLbl.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            CATransaction.begin()
            UIView.transition(with: huddleDescLbl, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.huddleDescLbl.textColor = UIColor(white: 0.4, alpha: 1)
            })
            UIView.transition(with: huddleNameLbl, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.huddleNameLbl.textColor = UIColor(white: 0.7, alpha: 1)
            })
            UIView.transition(with: usersCountLbl, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.usersCountLbl.textColor = UIColor(white: 0.7, alpha: 1)
            })
            CATransaction.commit()
        } else {
            CATransaction.begin()
            UIView.transition(with: huddleDescLbl, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.huddleDescLbl.textColor = UIColor(white: 0.7, alpha: 1)
            })
            UIView.transition(with: huddleNameLbl, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.huddleNameLbl.textColor = UIColor(white: 1, alpha: 1)
            })
            UIView.transition(with: usersCountLbl, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.usersCountLbl.textColor = UIColor(white: 1, alpha: 1)
            })
            CATransaction.commit()
        }
    }

    
}
