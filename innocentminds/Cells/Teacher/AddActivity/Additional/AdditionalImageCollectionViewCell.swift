//
//  AdditionalImageCollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/6/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AdditionalImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var labelImageCount: UILabel!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initializeViews() {
        self.layer.cornerRadius = Dimensions.cornerRadiusSmall
    }
    
}
