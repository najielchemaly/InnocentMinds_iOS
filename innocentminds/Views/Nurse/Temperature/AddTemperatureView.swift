//
//  AddTemperatureView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AddTemperatureView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var textFieldTemperature: UITextField!
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var buttonAdd: UIButton!
    
    var mode: ActionMode = .add
    var selectedTemperatureIndex = 0
    var childTemperature: ChildTemperature = ChildTemperature()
    
    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    
    let tempComponent1: [String] = [
        "35", "36", "37", "38", "39", "40"
    ]
    
    let tempComponent2: [String] = [
        "0", "1", "2", "3", "4",
        "5", "6", "7", "8", "9"
    ]
   
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
        self.textFieldComment.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonAdd.layer.cornerRadius = self.buttonAdd.frame.height/2
        
        if self.mode == .edit {
            self.textFieldTime.text = childTemperature.date
            self.textFieldTemperature.text = childTemperature.temperature
            self.textFieldComment.text = childTemperature.comment
            
            self.buttonAdd.setTitle(Localization.string(key: MessageKey.Save), for: .normal)
        }
        
        self.setupDatePicker()
        self.setupTempPickerView()
        self.updateTimeOfTemperature(date: Date())
    }
    
    func setupTempPickerView() {
        self.pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.textFieldTemperature.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Cancel), style: .plain, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Done), style: .plain, target: self, action: #selector(self.doneTempButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldTemperature.inputAccessoryView = toolbar
    }
    
    func setupDatePicker() {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .time
        self.textFieldTime.inputView = self.datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Cancel), style: .plain, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Done), style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldTime.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        self.updateTimeOfTemperature(date: self.datePicker.date)
        self.textFieldTime.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? self.tempComponent1.count : self.tempComponent2.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? self.tempComponent1[row] : self.tempComponent2[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.updateTemperature()
    }
    
    @objc func doneTempButtonTapped() {
        self.updateTemperature()
        self.textFieldTemperature.resignFirstResponder()
    }
    
    func updateTemperature() {
        let row1 = self.pickerView.selectedRow(inComponent: 0)
        let row2 = self.pickerView.selectedRow(inComponent: 1)
        
        let temp1 = self.tempComponent1[row1]
        let temp2 = self.tempComponent2[row2]
        
        self.textFieldTemperature.text = "\(temp1):\(temp2)"
    }
    
    func updateTimeOfTemperature(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.childTemperature.date = dateFormatter.string(from: date)
        let calendar = Calendar.current
        let component = calendar.dateComponents([.hour, .minute], from: date)
        if let hour = component.hour, let minute = component.minute {
            let hourFormat = hour < 12 ? "AM" : "PM"
            let hourFormatted = hour < 12 ? hour : hour-12
            let minuteFormatted = minute < 10 ? "0\(minute)" : "\(minute)"
            let time = "\(hourFormatted):\(minuteFormatted) \(hourFormat)"
            self.textFieldTime.text = time
        }
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
    @IBAction func buttonAddTapped(_ sender: Any) {
        if let nurseStudentDetailVC = currentVC as? NurseStudentDetailViewController {
            if isValidData() {
                self.childTemperature.child_id = nurseStudentDetailVC.selectedStudent.id ?? "0"
//                self.childTemperature.date = self.textFieldTime.text
                self.childTemperature.temperature = self.textFieldTemperature.text
                self.childTemperature.comment = self.textFieldComment.text
                
                if mode == .add {
                    nurseStudentDetailVC.childTemperatures.append(self.childTemperature)
                } else if mode == .edit {
                    nurseStudentDetailVC.childTemperatures[self.selectedTemperatureIndex] = self.childTemperature
                }
                
                nurseStudentDetailVC.tableView.reloadData()
                nurseStudentDetailVC.shouldAskBeforeLeaving = true
                
                self.hide()
            } else {
                nurseStudentDetailVC.showAlertView(message: errorMessage, isError: true)
            }
        }
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if self.textFieldTime.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.TimeEmpty)
            return false
        } else if self.textFieldTemperature.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.TemperatureEmpty)
            return false
        }
//        else if self.textFieldComment.text.isNullOrEmpty() {
//            errorMessage = Localization.string(key: MessageKey.CommentEmpty)
//            return false
//        }
        
        return true
    }
    
}
