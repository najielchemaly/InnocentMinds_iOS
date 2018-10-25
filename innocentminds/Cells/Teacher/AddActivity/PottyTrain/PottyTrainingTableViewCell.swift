//
//  PottyTrainingTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class PottyTrainingTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var buttonSad: UIButton!
    
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
        
        self.setupDatePicker()
    }
    
    func setupDatePicker() {
        if let baseVC = currentVC as? BaseViewController {
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
    
    @objc func doneButtonTapped() {
        if let addDailyAgendaVC = currentVC as? AddDailyAgendaViewController {
            let calendar = Calendar.current
            let component = calendar.dateComponents([.hour, .minute], from: self.datePicker.date)
            if let hour = component.hour, let minute = component.minute {
                let hourFormat = hour < 12 ? "AM" : "PM"
                let hourFormatted = hour < 12 ? hour : hour-12
                let minuteFormatted = minute < 10 ? "0\(minute)" : "\(minute)"
                let time = "\(hourFormatted):\(minuteFormatted) \(hourFormat)"
                self.textFieldTime.text = time
                addDailyAgendaVC.activity.time = time
            }
            
            addDailyAgendaVC.dismissKeyboard()
        }
    }
    
}
