//
//  MessageMeTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class MessageMeTableViewCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        self.messageView.layer.cornerRadius = Dimensions.cornerRadiusNormal
    }
    
}
