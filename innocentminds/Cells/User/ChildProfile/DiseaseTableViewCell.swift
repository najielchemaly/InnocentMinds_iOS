//
//  DiseaseTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/13/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class DiseaseTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonTitle: UIButton!
    @IBOutlet weak var imageViewCheck: UIImageView!
    
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
    }
    
}
