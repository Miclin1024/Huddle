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
        huddleDescLbl.textColor = .white
        huddleNameLbl.textColor = .white
        usersCountLbl.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
