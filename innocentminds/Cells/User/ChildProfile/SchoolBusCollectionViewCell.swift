//
//  SchoolBusCollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/12/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class SchoolBusCollectionViewCell: FSPagerViewCell, UITextFieldDelegate {

    @IBOutlet weak var viewPerson1: UIView!
    @IBOutlet weak var viewPerson2: UIView!
    @IBOutlet weak var viewPerson3: UIView!
    @IBOutlet weak var textFieldPerson1Fullname: UITextField!
    @IBOutlet weak var textFieldPerson1Phone: UITextField!
    @IBOutlet weak var textFieldPerson1Relation: UITextField!
    @IBOutlet weak var textFieldPerson2Fullname: UITextField!
    @IBOutlet weak var textFieldPerson2Phone: UITextField!
    @IBOutlet weak var textFieldPerson2Relation: UITextField!
    @IBOutlet weak var textFieldPerson3Fullname: UITextField!
    @IBOutlet weak var textFieldPerson3Phone: UITextField!
    @IBOutlet weak var textFieldPerson3Relation: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeViews() {
        self.contentView.layer.shadowRadius = 0
        
        self.viewPerson1.customizeView(width: Dimensions.cornerRadiusHigh)        
        self.viewPerson2.customizeView(width: Dimensions.cornerRadiusHigh)
        self.viewPerson3.customizeView(width: Dimensions.cornerRadiusHigh)
        
        self.setupDelegates()
    }
    
    func setupDelegates() {
        self.textFieldPerson1Fullname.delegate = self
        self.textFieldPerson1Phone.delegate = self
        self.textFieldPerson1Relation.delegate = self
        
        self.textFieldPerson2Fullname.delegate = self
        self.textFieldPerson2Phone.delegate = self
        self.textFieldPerson2Relation.delegate = self
        
        self.textFieldPerson3Fullname.delegate = self
        self.textFieldPerson3Phone.delegate = self
        self.textFieldPerson3Relation.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFieldPerson1Fullname.isFirstResponder {
            self.textFieldPerson1Phone.becomeFirstResponder()
        } else if self.textFieldPerson1Phone.isFirstResponder {
            self.textFieldPerson1Relation.becomeFirstResponder()
        } else if self.textFieldPerson1Relation.isFirstResponder {
            self.textFieldPerson2Fullname.becomeFirstResponder()
        } else if self.textFieldPerson2Fullname.isFirstResponder {
            self.textFieldPerson2Phone.becomeFirstResponder()
        } else if self.textFieldPerson2Phone.isFirstResponder {
            self.textFieldPerson2Relation.becomeFirstResponder()
        } else if self.textFieldPerson2Relation.isFirstResponder {
            self.textFieldPerson3Fullname.becomeFirstResponder()
        } else if self.textFieldPerson3Fullname.isFirstResponder {
            self.textFieldPerson3Phone.becomeFirstResponder()
        } else if self.textFieldPerson3Phone.isFirstResponder {
            self.textFieldPerson3Relation.becomeFirstResponder()
        } else if let baseVC = currentVC as? BaseViewController {
            baseVC.dismissKeyboard()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            if self.textFieldPerson1Fullname.isFirstResponder {
                
            } else if self.textFieldPerson1Phone.isFirstResponder {
                
            } else if self.textFieldPerson1Relation.isFirstResponder {
                
            } else if self.textFieldPerson2Fullname.isFirstResponder {
                
            } else if self.textFieldPerson2Phone.isFirstResponder {
                
            } else if self.textFieldPerson2Relation.isFirstResponder {
                
            } else if self.textFieldPerson3Fullname.isFirstResponder {
                
            } else if self.textFieldPerson3Phone.isFirstResponder {
                
            } else if self.textFieldPerson3Relation.isFirstResponder {
                
            }
        }
        
        return true
    }

}
