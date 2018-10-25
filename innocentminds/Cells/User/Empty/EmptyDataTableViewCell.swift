//
//  EmptyDataTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/24/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class EmptyDataTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
