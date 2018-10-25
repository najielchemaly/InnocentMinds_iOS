//
//  SearchTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/2/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelClass: UILabel!
    
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
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.height/2
    }
    
}
