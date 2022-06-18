//
//  RegisterChildStep2CollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/31/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class RegisterChildStep2CollectionViewCell: FSPagerViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var buttonMother: UIButton!
    @IBOutlet weak var buttonFather: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textFieldFirstname: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonIAmTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            switch button.tag {
            case 1:
                self.setButtonMotherSelected()
            case 2:
                self.setButtonFatherSelected()
            default:
                break
            }
        }
    }
    
    func initializeViews() {
        self.contentView.layer.shadowRadius = 0
        
        self.mainView.customizeView(width: Dimensions.cornerRadiusHigh)
        self.buttonMother.customizeView(width: self.buttonMother.frame.height/2)
        self.buttonFather.customizeView(width: self.buttonFather.frame.height/2)
        
        self.setupKeyboardObservers()
    }
    
    func setButtonMotherSelected() {
        self.buttonMother.backgroundColor = Colors.white
        self.buttonMother.setTitleColor(Colors.appBlue, for: .normal)
        
        self.buttonFather.backgroundColor = .clear
        self.buttonFather.setTitleColor(Colors.white, for: .normal)
        
        if let registerChildVC = currentVC as? RegisterChildViewController {
            registerChildVC.tempUser.parent_type = ParentType.Mother.rawValue
        }
    }
    
    func setButtonFatherSelected() {
        self.buttonFather.backgroundColor = Colors.white
        self.buttonFather.setTitleColor(Colors.appBlue, for: .normal)
        
        self.buttonMother.backgroundColor = .clear
        self.buttonMother.setTitleColor(Colors.white, for: .normal)
        
        if let registerChildVC = currentVC as? RegisterChildViewController {
            registerChildVC.tempUser.parent_type = ParentType.Father.rawValue
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFieldFirstname.isFirstResponder {
            self.textFieldLastname.becomeFirstResponder()
        } else if self.textFieldLastname.isFirstResponder {
            self.textFieldPhone.becomeFirstResponder()
        } else if self.textFieldPhone.isFirstResponder {
            self.textFieldEmail.becomeFirstResponder()
        } else if textFieldEmail.isFirstResponder {
            self.textFieldAddress.becomeFirstResponder()
        } else if let baseVC = currentVC as? BaseViewController {
            baseVC.dismissKeyboard()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateKeyboardInput()
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        self.updateKeyboardInput()
//        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.labelTopConstraint.constant = 0
        self.stackBottomConstraint.constant = 8
        self.mainBottomConstraint.constant = 8
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func updateKeyboardInput() {
        if self.textFieldEmail.isFirstResponder {
            self.labelTopConstraint.constant = -50
            self.stackBottomConstraint.constant = 50
            self.mainBottomConstraint.constant = 50
        } else if self.textFieldAddress.isFirstResponder {
            self.labelTopConstraint.constant = -100
            self.stackBottomConstraint.constant = 100
            self.mainBottomConstraint.constant = 100
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let registerChildVC = currentVC as? RegisterChildViewController {
            if textField == self.textFieldFirstname, let text = textField.text {
                registerChildVC.tempUser.firstname = "\(text)\(string)".replacingOccurrences(of: " ", with: "")
            } else if textField == self.textFieldLastname, let text = textField.text {
                registerChildVC.tempUser.lastname = "\(text)\(string)".replacingOccurrences(of: " ", with: "")
            } else if textField == self.textFieldPhone, let text = textField.text {
                registerChildVC.tempUser.phone = "\(text)\(string)".replacingOccurrences(of: " ", with: "")
            } else if textField == self.textFieldEmail, let text = textField.text {
                registerChildVC.tempUser.email = "\(text)\(string)".replacingOccurrences(of: " ", with: "")
            } else if textField == self.textFieldAddress, let text = textField.text {
                registerChildVC.tempUser.address = "\(text)\(string)".replacingOccurrences(of: " ", with: "")
            }
        }
        
        return true
    }
    
}
