//
//  PaymentTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/2/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAmountTitle: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
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
        self.mainView.layer.cornerRadius = Dimensions.cornerRadiusMedium
    }
    
}
