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
        
        self.setupPickerViews()
    }
    
    func setupPickerViews() {
        if let baseVC = currentVC as? BaseViewController {
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            
            self.datePicker = UIDatePicker()
            self.datePicker.datePickerMode = .time
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
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.textFieldType.isFirstResponder {
            return 0
        } else if self.textFieldPottyType.isFirstResponder {
            return 0
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.textFieldType.isFirstResponder {
            return nil
        } else if self.textFieldPottyType.isFirstResponder {
            return nil
        }
        
        return nil
    }
    
    @objc func doneButtonTapped() {
        if let addDailyAgendaVC = currentVC as? AddDailyAgendaViewController {
            if self.textFieldType.isFirstResponder {
                self.textFieldType.text = nil
                addDailyAgendaVC.activity.bath_type_id = nil
            } else if self.textFieldPottyType.isFirstResponder {
                self.textFieldPottyType.text = nil
                addDailyAgendaVC.activity.bath_potty_type_id = nil
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
