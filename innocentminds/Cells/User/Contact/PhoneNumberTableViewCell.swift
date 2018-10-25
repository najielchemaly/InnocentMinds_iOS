//
//  PhoneNumberTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/29/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class PhoneNumberTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buttonCall: UIButton!
    
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
