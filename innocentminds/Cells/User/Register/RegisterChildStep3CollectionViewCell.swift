//
//  RegisterChildStep3CollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/31/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class RegisterChildStep3CollectionViewCell: FSPagerViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textFieldDateOfEntry: UITextField!
    @IBOutlet weak var textFieldHearAboutUs: UITextField!
    @IBOutlet weak var textFieldBranch: UITextField!
    
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    
    var branches: [Branch] = [Branch]()
    var hearAboutUs: [HearAboutUs] = [HearAboutUs]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeViews() {
        self.contentView.layer.shadowRadius = 0
        
        self.mainView.customizeView(width: Dimensions.cornerRadiusHigh)
        
        if let branches = Objects.variables.branches {
            self.branches = branches
        }
        if let hearAboutUs = Objects.variables.hear_about_us {
            self.hearAboutUs = hearAboutUs
        }
        
        self.setupPickerViews()
    }
    
    func setupPickerViews() {
        if let baseVC = currentVC as? BaseViewController {
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            
            self.textFieldBranch.inputView = self.pickerView
            self.textFieldHearAboutUs.inputView = self.pickerView
            
            self.datePicker = UIDatePicker()
            self.datePicker.datePickerMode = .date
            self.textFieldDateOfEntry.inputView = self.datePicker
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: baseVC.view.frame.width, height: 44))
            toolbar.sizeToFit()
            toolbar.barStyle = .default
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: baseVC, action: #selector(baseVC.dismissKeyboard))
            cancelButton.tintColor = Colors.appBlue
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
            doneButton.tintColor = Colors.appBlue
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            toolbar.items = [cancelButton, flexibleSpace, doneButton]
            
            self.textFieldDateOfEntry.inputAccessoryView = toolbar
            self.textFieldBranch.inputAccessoryView = toolbar
            self.textFieldHearAboutUs.inputAccessoryView = toolbar
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.textFieldBranch.isFirstResponder {
            return 3
        } else if self.textFieldHearAboutUs.isFirstResponder {
            return 5
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.textFieldBranch.isFirstResponder {
            return self.branches[row].title
        } else if self.textFieldHearAboutUs.isFirstResponder {
            return self.hearAboutUs[row].title
        }
        
        return nil
    }
    
    @objc func doneButtonTapped() {
        if let registerChildVC = currentVC as? RegisterChildViewController, let child = registerChildVC.tempUser.children?.first {
            let row = self.pickerView.selectedRow(inComponent: 0)
            if self.textFieldBranch.isFirstResponder {
                self.textFieldBranch.text = self.branches[row].title
                child.branch_id = self.branches[row].id
            } else if self.textFieldHearAboutUs.isFirstResponder {
                self.textFieldHearAboutUs.text = self.hearAboutUs[row].title
                registerChildVC.tempUser.hear_about_us = self.hearAboutUs[row].id
            } else {
                self.handleDatePicker()
            }
            
            if let baseVC = currentVC as? BaseViewController {
                baseVC.dismissKeyboard()
            }
        }
    }
    
    func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.textFieldDateOfEntry.text = dateFormatter.string(from: self.datePicker.date)
        
        if let registerChildVC = currentVC as? RegisterChildViewController, let child = registerChildVC.tempUser.children?.first {
            if let text = self.textFieldDateOfEntry.text {
                child.desired_date_of_entry = text
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFieldDateOfEntry.isFirstResponder {
            self.textFieldBranch.becomeFirstResponder()
        } else if self.textFieldBranch.isFirstResponder {
            self.textFieldHearAboutUs.becomeFirstResponder()
        } else if let baseVC = currentVC as? BaseViewController {
            baseVC.dismissKeyboard()
        }
        
        return true
    }

}
