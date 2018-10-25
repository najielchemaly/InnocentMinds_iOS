//
//  TemperatureTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class TemperatureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeView() {
        self.mainView.layer.cornerRadius = Dimensions.cornerRadiusNormal
    }
    
}
