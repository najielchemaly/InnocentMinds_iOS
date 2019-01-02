//
//  RegisterChildStep1CollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/31/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class RegisterChildStep1CollectionViewCell: FSPagerViewCell, UITextFieldDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldDateOfBirth: UITextField!
    @IBOutlet weak var buttonNotBornYet: UIButton!
    
    var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeViews() {
        self.contentView.layer.shadowRadius = 0
        
        self.mainView.customizeView(width: Dimensions.cornerRadiusHigh)
        
        self.buttonNotBornYet.customizeView(width: self.buttonNotBornYet.frame.height/2)
        
        self.buttonNotBornYet.setTitleColor(Colors.appBlue, for: .selected)
        self.buttonNotBornYet.setTitleColor(Colors.white, for: .normal)
        
        self.setupDatePicker()
    }
    
    func setupDatePicker() {
        if let baseVC = currentVC as? BaseViewController {
            self.datePicker = UIDatePicker()
            self.datePicker.datePickerMode = .date
            self.datePicker.maximumDate = Date()
            self.textFieldDateOfBirth.inputView = self.datePicker
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: baseVC.view.frame.width, height: 44))
            toolbar.sizeToFit()
            toolbar.barStyle = .default
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: baseVC, action: #selector(baseVC.dismissKeyboard))
            cancelButton.tintColor = Colors.appBlue
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
            doneButton.tintColor = Colors.appBlue
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            toolbar.items = [cancelButton, flexibleSpace, doneButton]
            
            self.textFieldDateOfBirth.inputAccessoryView = toolbar
        }
    }
    
    @objc func doneButtonTapped() {
        self.handleDatePicker()
        
        if let baseVC = currentVC as? BaseViewController {
            baseVC.dismissKeyboard()
        }
    }
    
    func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.textFieldDateOfBirth.text = dateFormatter.string(from: self.datePicker.date)
        
        if let registerChildVC = currentVC as? RegisterChildViewController, let child = registerChildVC.tempUser.children?.first {
            if let text = self.textFieldDateOfBirth.text {
                child.date_of_birth = text
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFieldFirstName.isFirstResponder {
            self.textFieldLastName.becomeFirstResponder()
        } else if self.textFieldFirstName.isFirstResponder {
            self.textFieldDateOfBirth.becomeFirstResponder()
        } else if let baseVC = currentVC as? BaseViewController {
            baseVC.dismissKeyboard()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let registerChildVC = currentVC as? RegisterChildViewController, let child = registerChildVC.tempUser.children?.first {
            if textField == self.textFieldFirstName, let text = textField.text {
                child.firstname = "\(text)\(string)".replacingOccurrences(of: " ", with: "")
            } else if textField == self.textFieldLastName, let text = textField.text {
                child.lastname = "\(text)\(string)".replacingOccurrences(of: " ", with: "")
            }
        }
        
        return true
    }

    @IBAction func buttonNotBornYetTapped(_ sender: Any) {
        self.textFieldDateOfBirth.text = nil
        
        self.buttonNotBornYet.isSelected = !self.buttonNotBornYet.isSelected
        
        if self.buttonNotBornYet.isSelected {
            self.buttonNotBornYet.backgroundColor = Colors.white
            
            self.textFieldDateOfBirth.isEnabled(enable: false)
        } else {
            self.buttonNotBornYet.backgroundColor = .clear
            
            self.textFieldDateOfBirth.isEnabled(enable: true)
        }
        
        if let registerChildVC = currentVC as? RegisterChildViewController, let child = registerChildVC.tempUser.children?.first {
            child.is_born = !self.buttonNotBornYet.isSelected
            child.date_of_birth = ""
        }
    }
    
}
