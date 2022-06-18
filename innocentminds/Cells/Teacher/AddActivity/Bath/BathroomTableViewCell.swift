//
//  BathroomTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class BathroomTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var textFieldType: UITextField!
    @IBOutlet weak var textFieldPottyType: UITextField!
    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var buttonSad: UIButton!
    
    var pickerView: UIPickerView!
    var datePicker: UIDatePicker!
    
    var bathTypes: [BathType] = [BathType]()
    var bathPottyTypes: [BathPottyType] = [BathPottyType]()
    
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
        self.layer.cornerRadius = Dimensions.cornerRadiusNormal
        
        if let bathTypes = Objects.variables.bath_types {
            self.bathTypes = bathTypes
        }
        
        if let bathPottyTypes = Objects.variables.bath_potty_types {
            self.bathPottyTypes = bathPottyTypes
        }
        
        self.setupPickerViews()
    }
    
    func setupPickerViews() {
        if let baseVC = currentVC as? BaseViewController {
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            self.textFieldType.inputView = self.pickerView
            self.textFieldPottyType.inputView = self.pickerView
            
            self.datePicker = UIDatePicker()
            self.datePicker.datePickerMode = .time
            self.datePicker.locale = Locale(identifier: Localization.currentLanguage())
            self.textFieldTime.inputView = self.datePicker
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: baseVC.view.frame.width, height: 44))
            toolbar.sizeToFit()
            toolbar.barStyle = .default
            let cancelButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Cancel), style: .plain, target: baseVC, action: #selector(baseVC.dismissKeyboard))
            cancelButton.tintColor = Colors.appBlue
            let doneButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Done), style: .plain, target: self, action: #selector(self.doneButtonTapped))
            doneButton.tintColor = Colors.appBlue
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            toolbar.items = [cancelButton, flexibleSpace, doneButton]
            
            self.textFieldTime.inputAccessoryView = toolbar
            self.textFieldType.inputAccessoryView = toolbar
            self.textFieldPottyType.inputAccessoryView = toolbar
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.textFieldType.isFirstResponder {
            return self.bathTypes.count
        } else if self.textFieldPottyType.isFirstResponder {
            return self.bathPottyTypes.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.textFieldType.isFirstResponder {
            return self.bathTypes[row].title
        } else if self.textFieldPottyType.isFirstResponder {
            return self.bathPottyTypes[row].title
        }
        
        return nil
    }
    
    @objc func doneButtonTapped() {
        if let addDailyAgendaVC = currentVC as? AddDailyAgendaViewController {
            let row = self.pickerView.selectedRow(inComponent: 0)
            if self.textFieldType.isFirstResponder {
                self.textFieldType.text = self.bathTypes[row].title
                addDailyAgendaVC.activity.bath_type_id = self.bathTypes[row].id
            } else if self.textFieldPottyType.isFirstResponder {
                self.textFieldPottyType.text = self.bathPottyTypes[row].title
                addDailyAgendaVC.activity.bath_potty_type_id = self.bathPottyTypes[row].id
            } else if self.textFieldTime.isFirstResponder {
                let calendar = Calendar.current
                let component = calendar.dateComponents([.hour, .minute, .second], from: self.datePicker.date)
                if let hour = component.hour, let minute = component.minute {
                    let hourFormat = hour < 12 ? "AM" : "PM"
                    let hourFormatted = hour < 12 ? hour : hour-12
                    let minuteFormatted = minute < 10 ? "0\(minute)" : "\(minute)"
                    let time = "\(hourFormatted):\(minuteFormatted) \(hourFormat)"
                    self.textFieldTime.text = time
                    addDailyAgendaVC.activity.time = time
                }
            }
            
            addDailyAgendaVC.dismissKeyboard()
        }
    }
    
}
