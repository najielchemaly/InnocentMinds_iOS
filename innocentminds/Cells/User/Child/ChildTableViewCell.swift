//
//  ChildTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class ChildTableViewCell: UITableViewCell {

    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var labelChildName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        self.childImageView.layer.cornerRadius = self.childImageView.frame.height/2
    }
    
}
