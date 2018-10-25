//
//  SendUsMessageTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/29/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SendUsMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        self.mainView.layer.cornerRadius = Dimensions.cornerRadiusNormal
    }
    
}
