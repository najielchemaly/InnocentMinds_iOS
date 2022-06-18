//
//  AlertView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/23/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AlertView: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonOk: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitleTopConstraint: NSLayoutConstraint!
    
    func initializeViews() {
        self.mainView.layer.cornerRadius = Dimensions.cornerRadiusHigh
        
        self.buttonOk.layer.cornerRadius = self.buttonOk.frame.height/2
        self.buttonOk.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.buttonCancel.layer.cornerRadius = self.buttonCancel.frame.height/2
        self.buttonCancel.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
