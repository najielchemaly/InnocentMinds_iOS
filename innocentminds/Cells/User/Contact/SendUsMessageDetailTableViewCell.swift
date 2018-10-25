//
//  SendUsMessageDetailTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/30/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SendUsMessageDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewBranch: UIView!
    @IBOutlet weak var viewInquiry: UIView!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        self.viewFirstName.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewLastName.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewEmail.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewPhoneNumber.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewBranch.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewInquiry.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonSend.layer.cornerRadius = self.buttonSend.frame.height/2
    }
    
}
