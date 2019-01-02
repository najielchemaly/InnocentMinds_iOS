//
//  ImageFullCollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/30/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class ImageFullCollectionViewCell: FSPagerViewCell {
    
    @IBOutlet weak var imageViewFull: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.shadowRadius = 0
    }

}
