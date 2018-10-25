//
//  PediatricianCollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/13/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class PediatricianCollectionViewCell: FSPagerViewCell, UITextFieldDelegate {

    @IBOutlet weak var textFieldFullname: UITextField!
    @IBOutlet weak var textFieldWorkPlace: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeViews() {
        self.contentView.layer.shadowRadius = 0
        
        self.textFieldFullname.customizeView(width: Dimensions.cornerRadiusNormal)
        self.textFieldWorkPlace.customizeView(width: Dimensions.cornerRadiusNormal)
        self.textFieldPhone.customizeView(width: Dimensions.cornerRadiusNormal)
        self.textFieldEmail.customizeView(width: Dimensions.cornerRadiusNormal)
        
        self.setupDelegates()
    }
    
    func setupDelegates() {
        self.textFieldFullname.delegate = self
        self.textFieldWorkPlace.delegate = self
        self.textFieldPhone.delegate = self
        self.textFieldEmail.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFieldFullname.isFirstResponder {
            self.textFieldWorkPlace.becomeFirstResponder()
        } else if self.textFieldWorkPlace.isFirstResponder {
            self.textFieldPhone.becomeFirstResponder()
        } else if self.textFieldPhone.isFirstResponder {
            self.textFieldEmail.becomeFirstResponder()
        } else if let baseVC = currentVC as? BaseViewController {
            baseVC.dismissKeyboard()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            if self.textFieldFullname.isFirstResponder {
                editChildProfileVC.selectedChild.ped_fullname = self.textFieldFullname.text
            } else if self.textFieldWorkPlace.isFirstResponder {
                editChildProfileVC.selectedChild.ped_workplace = self.textFieldWorkPlace.text
            } else if self.textFieldPhone.isFirstResponder {
                editChildProfileVC.selectedChild.ped_phone = self.textFieldPhone.text
            } else if self.textFieldEmail.isFirstResponder {
                editChildProfileVC.selectedChild.ped_email = self.textFieldEmail.text
            }
        }
        
        return true
    }
    
}
