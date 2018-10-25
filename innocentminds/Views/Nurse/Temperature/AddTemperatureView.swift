//
//  AddTemperatureView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AddTemperatureView: UIView {

    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var textFieldTemperature: UITextField!
    @IBOutlet weak var buttonAdd: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func initializeViews() {
        self.textFieldTime.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.textFieldTemperature.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonAdd.layer.cornerRadius = self.buttonAdd.frame.height/2
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
}
