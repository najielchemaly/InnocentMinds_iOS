//
//  AddPhotosCollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/21/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AddPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var addMoreView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeViews() {
        self.mainView.layer.cornerRadius = Dimensions.cornerRadiusSmall
        self.addMoreView.layer.cornerRadius = Dimensions.cornerRadiusSmall
    }

}
