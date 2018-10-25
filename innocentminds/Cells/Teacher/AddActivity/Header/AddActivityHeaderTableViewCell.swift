//
//  AddActivityHeaderTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/6/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AddActivityHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
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
        self.selectionStyle = .none
        self.mainView.layer.cornerRadius = Dimensions.cornerRadiusNormal
    }
    
}
