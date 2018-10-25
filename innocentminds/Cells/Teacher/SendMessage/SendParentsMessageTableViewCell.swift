//
//  SendParentsMessageTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/14/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SendParentsMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelDescription: UILabel!
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
        self.mainView.backgroundColor = Colors.white
    }
    
    func updateSelectedMessage(isSelected: Bool) {
        if isSelected {
            self.mainView.backgroundColor = Colors.appBlue
            self.labelDescription.textColor = Colors.white
        } else {
            self.mainView.backgroundColor = Colors.white
            self.labelDescription.textColor = Colors.textDark
        }
    }
    
}
