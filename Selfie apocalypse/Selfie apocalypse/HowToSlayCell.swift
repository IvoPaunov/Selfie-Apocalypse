//
//  HowToSlayCell.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/7/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit

class HowToSlayCell: UITableViewCell {

    @IBOutlet weak var weaponImageViwe: UIImageView!
   
    
    @IBOutlet weak var weaponTitleLabel: UILabel!
    
    
    @IBOutlet weak var weaponDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
