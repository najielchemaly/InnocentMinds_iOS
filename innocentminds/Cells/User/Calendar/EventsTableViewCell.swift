//
//  CalendarTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 2/8/19.
//  Copyright © 2019 infosys. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.selectionStyle = .none
        self.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.layer.borderColor = Colors.lightGray.cgColor
        self.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
