//
//  AddActivityPostTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/6/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AddActivityPostTableViewCell: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonStar1: UIButton!
    @IBOutlet weak var buttonStar2: UIButton!
    @IBOutlet weak var buttonStar3: UIButton!
    @IBOutlet weak var buttonStar4: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stackViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var labelTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelDescriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewStudents: UIButton!
    @IBOutlet weak var buttonViewImages: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
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
        self.topView.layer.cornerRadius = Dimensions.cornerRadiusNormal
    }
    
}
