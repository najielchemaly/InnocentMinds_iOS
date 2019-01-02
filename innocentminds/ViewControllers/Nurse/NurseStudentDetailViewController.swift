//
//  NurseStudentDetailViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class NurseStudentDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelChildName: UILabel!
    @IBOutlet weak var buttonArrived: UIButton!
    @IBOutlet weak var viewTimeOfArrival: UIView!
    @IBOutlet weak var mainViewTimeOfArrival: UIView!
    @IBOutlet weak var textFieldTimeOfArrival: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSubmitTemperature: UIButton!
    
    var selectedStudent: Child = Child()
    var childTemperatures: [ChildTemperature] = [ChildTemperature]()
    var shouldAskBeforeLeaving: Bool = false
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupDatePicker()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.buttonBack.imageView?.contentMode = .scaleAspectFit
        
        self.buttonSubmitTemperature.layer.cornerRadius = self.buttonSubmitTemperature.frame.height/2
        
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.height/2
        
        if let image = self.selectedStudent.image, !image.isEmpty {
            self.imageViewProfile.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
            self.imageViewProfile.layer.borderColor = Colors.darkBlue.cgColor
            self.imageViewProfile.layer.borderWidth = 1
        }
        
        if let firstName = self.selectedStudent.firstname, let lastName = self.selectedStudent.lastname {
            self.labelChildName.text = "\(firstName) \(lastName)"
        }
        
        self.buttonArrived.customizeView()
        
        self.mainViewTimeOfArrival.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewTimeOfArrival.isEnabled(enable: false)
        
        if self.selectedStudent.has_arrived == true {
            self.buttonArrivedTapped(self.buttonArrived)
        }
        
        if let childTemps = self.selectedStudent.child_temps {
            self.childTemperatures = childTemps
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.TemperatureTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.TemperatureTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.TemperatureFooterTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.TemperatureFooterTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.childTemperatures.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == self.childTemperatures.count || self.childTemperatures.count == 0 ? 100 : self.childTemperatures[indexPath.row].comment.isNullOrEmpty() ? 70 : 105
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.childTemperatures.count == 0 || indexPath.row == self.childTemperatures.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TemperatureFooterTableViewCell) as? TemperatureFooterTableViewCell {
                cell.selectionStyle = .none
                cell.initializeViews()
                
                let cellTap = UITapGestureRecognizer(target: self, action: #selector(addTemperatureTapped))
                cell.mainView.addGestureRecognizer(cellTap)
                
                return cell
            }
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TemperatureTableViewCell) as? TemperatureTableViewCell {
            cell.selectionStyle = .none
            cell.initializeView()
            
            cell.buttonEdit.addTarget(self, action: #selector(buttonEditTapped(sender:)), for: .touchUpInside)
            cell.buttonEdit.tag = indexPath.row
            
            cell.buttonDelete.addTarget(self, action: #selector(buttonDeleteTapped(sender:)), for: .touchUpInside)
            cell.buttonDelete.tag = indexPath.row

            let childTemperature = self.childTemperatures[indexPath.row]
            
            let calendar = Calendar.current
            if let strDate = childTemperature.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: strDate) {
                    let component = calendar.dateComponents([.hour, .minute], from: date)
                    if let hour = component.hour, let minute = component.minute {
                        let hourFormat = hour < 12 ? "AM" : "PM"
                        let hourFormatted = hour < 12 ? hour : hour-12
                        let minuteFormatted = minute < 10 ? "0\(minute)" : "\(minute)"
                        let time = "\(hourFormatted):\(minuteFormatted) \(hourFormat)"
                        cell.labelTime.text = "at \(time)"
                    }
                }
            }
            
            cell.labelTemperature.text = "\(childTemperature.temperature ?? "0") °C"
            cell.labelComment.text = childTemperature.comment
            
            guard let childTemp = childTemperature.temperature else {
                return cell
            }
            
            let strTemp = childTemp.replacingOccurrences(of: ":", with: ".")
            guard let temp = Double(strTemp) else {
                return cell
            }
            
            cell.labelTemperature.textColor = temp > 38 ? Colors.appRed : Colors.darkBlue
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func buttonEditTapped(sender: UIButton) {
        if let addTemperatureView = self.showView(name: Views.AddTemperatureView) as? AddTemperatureView {
            addTemperatureView.mode = .edit
            addTemperatureView.childTemperature = self.childTemperatures[sender.tag]
            addTemperatureView.selectedTemperatureIndex = sender.tag
            addTemperatureView.initializeViews()
        }
    }
    
    var deleteTemperatureIndex = 0
    @objc func buttonDeleteTapped(sender: UIButton) {
        self.deleteTemperatureIndex = sender.tag
        self.showAlertView(message: Localization.string(key: MessageKey.DeleteTemperature), buttonOkTitle: Localization.string(key: MessageKey.Delete), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.deleteTemperature), for: .touchUpInside)
        }
    }
    
    @objc func deleteTemperature() {
//        if let temperatureToDeleteId = self.childTemperatures[self.deleteTemperatureIndex].id {
//            self.showLoader()
//
//            DispatchQueue.global(qos: .background).async {
//                _ = appDelegate.services.deleteTemperature(id: temperatureToDeleteId)
//
//                DispatchQueue.main.async {
//                    self.hideLoader()
//                    self.hideView()
//                }
//            }
//        } else {
//            self.hideView()
//        }
        
        self.childTemperatures.remove(at: self.deleteTemperatureIndex)
        self.tableView.reloadData()
        
        self.hideView()
    }
    
    @objc func addTemperatureTapped() {
        if let addTemperatureView = self.showView(name: Views.AddTemperatureView) as? AddTemperatureView {
            addTemperatureView.initializeViews()
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        if self.shouldAskBeforeLeaving {
            self.showAlertView(message: Localization.string(key: MessageKey.LeaveWithoutSaving), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel))
            
            if let alertView = self.customView as? AlertView {
                alertView.buttonOk.addTarget(self, action: #selector(self.popVC), for: .touchUpInside)
            }
        } else {
            self.popVC()
        }
    }
    
    @IBAction func buttonArrivedTapped(_ sender: Any) {
        self.buttonArrived.isSelected = !self.buttonArrived.isSelected
        self.updateButtonArrivedStatus()
    }
    
    @IBAction func buttonSubmitArrivalTapped(_ sender: Any) {
        if self.buttonArrived.isSelected && !self.textFieldTimeOfArrival.text.isNullOrEmpty() {
            self.submitStudentArrival()
//            self.showAlertView(message: Localization.string(key: MessageKey.SubmitStudentArrival), buttonOkTitle: Localization.string(key: MessageKey.Submit), buttonCancelTitle: Localization.string(key: MessageKey.Cancel))
//
//            if let alertView = self.customView as? AlertView {
//                alertView.buttonOk.addTarget(self, action: #selector(self.submitStudentArrival), for: .touchUpInside)
//            }
        }
    }
    
    @objc func submitStudentArrival() {
        self.showLoader()
        
        let studentId = self.selectedStudent.id ?? "0"
        let time = self.textFieldTimeOfArrival.text ?? ""
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.updateStudentStatus(childId: studentId, hasArrived: true, dateArrived: time)
            
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue {//, let message = result?.message {
//                    self.showAlertView(message: message)
                    guard let student = Objects.user.children?.first(where: { $0.id == self.selectedStudent.id }) else {
                        return
                    }
                    
                    student.has_arrived = true
                    student.date_arrived = time
                } else if let message = result?.message {
                    self.showAlertView(message: message, isError: true)
                } else {
                    self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                }
                
                self.hideLoader()
            }
        }
    }
    
    func updateButtonArrivedStatus() {
        self.buttonArrived.layer.borderWidth = self.buttonArrived.isSelected ? 0 : 1
        self.buttonArrived.backgroundColor = self.buttonArrived.isSelected ? Colors.selectedGreen : .clear
        
        self.viewTimeOfArrival.isEnabled(enable: self.buttonArrived.isSelected)
        
        if self.buttonArrived.isSelected {
            self.updateTimeOfArrival(date: Date())
        }
    }
    
    func setupDatePicker() {
        self.datePicker = UIDatePicker()
        self.datePicker.datePickerMode = .dateAndTime
        self.textFieldTimeOfArrival.inputView = self.datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Cancel), style: .plain, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Done), style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldTimeOfArrival.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        self.updateTimeOfArrival(date: self.datePicker.date)
        self.dismissKeyboard()
    }
    
    func updateTimeOfArrival(date: Date) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let time = formatter.string(from: date)
//        self.textFieldTimeOfArrival.text = time
        let calendar = Calendar.current
        let component = calendar.dateComponents([.hour, .minute], from: date)
        if let hour = component.hour, let minute = component.minute {
            let hourFormat = hour < 12 ? "AM" : "PM"
            let hourFormatted = hour < 12 ? hour : hour-12
            let minuteFormatted = minute < 10 ? "0\(minute)" : "\(minute)"
            let time = "\(hourFormatted):\(minuteFormatted) \(hourFormat)"
            self.textFieldTimeOfArrival.text = time
        }
    }
    
    @IBAction func buttonSubmitTemperatureTapped(_ sender: Any) {
        if self.childTemperatures.count > 1 {
            if let childId = self.selectedStudent.id, let id = Int(childId) {
                self.showLoader()
                
                let sendTemperature = SendTemperature(child_id: id, child_temperatures: self.childTemperatures)
                
                DispatchQueue.global(qos: .background).async {
                    let result = appDelegate.services.addTemperature(sendTemperature: sendTemperature)
                    
                    DispatchQueue.main.async {
                        if result?.status == ResponseStatus.SUCCESS.rawValue, let message = result?.message {
                            self.shouldAskBeforeLeaving = false
                            
                            guard let student = Objects.user.children?.first(where: { $0.id == self.selectedStudent.id }) else {
                                return
                            }
                            
                            student.child_temps = self.childTemperatures
//                            self.showAlertView(message: message)
                        } else if let message = result?.message {
                            self.showAlertView(message: message, isError: true)
                        } else {
                            self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                        }
                        
                        self.hideLoader()
                    }
                }
            }
        } else {
            self.showAlertView(message: Localization.string(key: MessageKey.TemperatureRequired), isError: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
