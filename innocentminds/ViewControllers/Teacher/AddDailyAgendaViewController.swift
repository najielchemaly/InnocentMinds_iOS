//
//  AddDailyAgendaViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/22/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AddDailyAgendaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldActivityType: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    var activity = Activity()
    var selectedActivityIndex = 0
    
    var pickerView: UIPickerView!    
    
    var selectedType: ActivityType = .Breakfast
    var mode: ActionMode = .add
    
    var activityTypes: [String] = [
        "Breakfast",
        "Lunch",
        "Nap",
        "Bathroom",
        "Pottry training"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPickerViews()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.textFieldActivityType.customizeView()
        self.buttonSave.customizeView(width: self.buttonSave.frame.height/2)
        
        if self.mode == .edit {
            self.textFieldActivityType.isEnabled(enable: false)
            
            if let typeId = activity.type_id, let row = Int(typeId) {
                self.textFieldActivityType.text = self.activityTypes[row-1]
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
    }
    
    func setupPickerViews() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.textFieldActivityType.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.dismissKeyboard))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldActivityType.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.activityTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.activityTypes[row]
    }
    
    @objc func doneButtonTapped() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.textFieldActivityType.text = self.activityTypes[row]
        
        switch row {
        case 0:
            self.selectedType = .Breakfast
        case 1:
            self.selectedType = .Lunch
        case 2:
            self.selectedType = .Nap
        case 3:
            self.selectedType = .Bathroom
        case 4:
            self.selectedType = .PottyTraining
        default:
            break
        }
        
        self.tableView.reloadData()
        self.dismissKeyboard()
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.BreakfastTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.BreakfastTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.LunchTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.LunchTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.NapTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.NapTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.BathroomTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.BathroomTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.PottyTrainingTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.PottyTrainingTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.selectedType {
        case .Breakfast, .Lunch, .Bathroom:
            return 150
        case .Nap, .PottyTraining:
            return 110
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.selectedType {
        case .Breakfast:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.BreakfastTableViewCell) as? BreakfastTableViewCell {
                cell.initializeViews()
                
                if self.mode == .add {
                    cell.stackView.setSelectedStar(index: 0)
                } else if self.mode == .edit {
                    if let rating = self.activity.rating, let index = Int(rating) {
                        let starIndex = index == -1 ? 0 : index
                        cell.stackView.setSelectedStar(index: starIndex)
                        
                        cell.buttonSad.isSelected = starIndex == 0
                    }
                    
                    cell.textView.text = self.activity.description
                }
                
                cell.buttonSad.addTarget(self, action: #selector(buttonSadTapped(sender:)), for: .touchUpInside)
                
                for view in cell.stackView.subviews {
                    if let button = view as? UIButton {
                        button.addTarget(self, action: #selector(buttonStarTapped(sender:)), for: .touchUpInside)
                    }
                }
                
                cell.textView.delegate = self
                
                return cell
            }
        case .Lunch:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.LunchTableViewCell) as? LunchTableViewCell {
                cell.initializeViews()
                
                if self.mode == .add {
                    cell.stackView.setSelectedStar(index: 0)
                } else if self.mode == .edit {
                    if let rating = self.activity.rating, let index = Int(rating) {
                        let starIndex = index == -1 ? 0 : index
                        cell.stackView.setSelectedStar(index: starIndex)
                        
                        cell.buttonSad.isSelected = starIndex == 0
                    }
                    
                    cell.textView.text = self.activity.description
                }
                
                cell.buttonSad.addTarget(self, action: #selector(buttonSadTapped(sender:)), for: .touchUpInside)
                
                for view in cell.stackView.subviews {
                    if let button = view as? UIButton {
                        button.addTarget(self, action: #selector(buttonStarTapped(sender:)), for: .touchUpInside)
                    }
                }
                
                cell.textView.delegate = self
                
                return cell
            }
        case .Nap:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.NapTableViewCell) as? NapTableViewCell {
                cell.initializeViews()
                
                if self.mode == .edit {
                    if let rating = self.activity.rating, let index = Int(rating) {
                        cell.buttonSad.isSelected = index == -1
                    }
                    
                    cell.textFieldFrom.text = self.activity.from_date
                    cell.textFieldTo.text = self.activity.to_date
                }
                
                cell.buttonSad.addTarget(self, action: #selector(buttonSadNapTapped(sender:)), for: .touchUpInside)
                
                return cell
            }
        case .Bathroom:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.BathroomTableViewCell) as? BathroomTableViewCell {
                cell.initializeViews()
                
                if self.mode == .edit {
                    if let rating = self.activity.rating, let index = Int(rating) {
                        cell.buttonSad.isSelected = index == -1
                    }
                    
                    cell.textFieldType.text = self.activity.bath_type_id
                    cell.textFieldPottyType.text = self.activity.bath_potty_type_id
                    cell.textFieldTime.text = self.activity.time
                }
                
                cell.buttonSad.addTarget(self, action: #selector(buttonSadBathTapped(sender:)), for: .touchUpInside)
                
                return cell
            }
        case .PottyTraining:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.PottyTrainingTableViewCell) as? PottyTrainingTableViewCell {
                cell.initializeViews()
                
                if self.mode == .edit {
                    if let rating = self.activity.rating, let index = Int(rating) {
                        cell.buttonSad.isSelected = index == -1
                    }
                    
                    cell.textFieldTime.text = self.activity.time
                }
                
                cell.buttonSad.addTarget(self, action: #selector(buttonSadPottyTapped(sender:)), for: .touchUpInside)
                
                return cell
            }
        default:
            break
        }
        
        return UITableViewCell()
    }

    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if let teacherStudentDetailVC = self.presentingViewController?.childViewControllers.last as? TeacherStudentDetailViewController {
            self.activity.child_id = teacherStudentDetailVC.selectedStudent.id ?? "0"
            switch self.selectedType {
            case .Breakfast:
                self.activity.type_id = ActivityType.Breakfast.rawValue
                self.activity.title = ActivityType.Breakfast.identifier
            case .Lunch:
                self.activity.type_id = ActivityType.Lunch.rawValue
                self.activity.title = ActivityType.Lunch.identifier
            case .Nap:
                self.activity.type_id = ActivityType.Nap.rawValue
                self.activity.title = ActivityType.Nap.identifier
            case .Bathroom:
                self.activity.type_id = ActivityType.Bathroom.rawValue
                self.activity.title = ActivityType.Bathroom.identifier
            case .PottyTraining:
                self.activity.type_id = ActivityType.PottyTraining.rawValue
                self.activity.title = ActivityType.PottyTraining.identifier
            default:
                break
            }
            
            if isValidData() {
                if self.mode == .add {
                    self.activity.id = "0"
                    teacherStudentDetailVC.dailyAgendas.append(self.activity)
                } else if self.mode == .edit {
                    teacherStudentDetailVC.dailyAgendas[self.selectedActivityIndex] = self.activity
                }
                
                teacherStudentDetailVC.shouldAskBeforeLeaving = true
                teacherStudentDetailVC.tableView.reloadData()
                
                self.dismissVC()
            } else {
                self.showAlertView(message: errorMessage, isError: true)
            }
        }
    }
    
    @objc func buttonSadTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BreakfastTableViewCell {
            cell.stackView.setSelectedStar(index: 0)
        } else if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LunchTableViewCell {
            cell.stackView.setSelectedStar(index: 0)
        }
        
        self.activity.rating = sender.isSelected ? "-1" : nil
    }
    
    @objc func buttonStarTapped(sender: UIButton) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BreakfastTableViewCell {
            cell.stackView.setSelectedStar(index: sender.tag)
            cell.buttonSad.isSelected = false
        } else if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LunchTableViewCell {
            cell.stackView.setSelectedStar(index: sender.tag)
            cell.buttonSad.isSelected = false
        }
        
        self.activity.rating = "\(sender.tag)"
    }
    
    @objc func buttonSadNapTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NapTableViewCell {
            cell.textFieldFrom.text = nil
            cell.textFieldFrom.isEnabled(enable: !sender.isSelected)
            cell.textFieldTo.text = nil
            cell.textFieldTo.isEnabled(enable: !sender.isSelected)
        }
        
        self.activity.rating = sender.isSelected ? "-1" : nil
    }
    
    @objc func buttonSadPottyTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PottyTrainingTableViewCell {
            cell.textFieldTime.text = nil
            cell.textFieldTime.isEnabled(enable: !sender.isSelected)
        }
        
        self.activity.rating = sender.isSelected ? "-1" : nil
    }
    
    @objc func buttonSadBathTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BathroomTableViewCell {
            cell.textFieldType.text = nil
            cell.textFieldType.isEnabled(enable: !sender.isSelected)
            
            cell.textFieldPottyType.text = nil
            cell.textFieldPottyType.isEnabled(enable: !sender.isSelected)
            
            cell.textFieldTime.text = nil
            cell.textFieldTime.isEnabled(enable: !sender.isSelected)
        }
        
        self.activity.rating = sender.isSelected ? "-1" : nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            self.activity.description = text
        }
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        switch self.selectedType {
        case .Breakfast:
            if self.activity.rating.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.Rating)
                return false
            }
        case .Lunch:
            if self.activity.rating.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.Rating)
                return false
            }
        case .Nap:
            if self.activity.rating.isNullOrEmpty() && (self.activity.from_date.isNullOrEmpty() || self.activity.to_date.isNullOrEmpty()) {
                errorMessage = Localization.string(key: MessageKey.NapTime)
                return false
            }
        case .Bathroom:
            if self.activity.rating.isNullOrEmpty() && self.activity.bath_type_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.BathType)
                return false
            }
            if self.activity.rating.isNullOrEmpty() && self.activity.bath_potty_type_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.BathPottyType)
                return false
            }
            if self.activity.rating.isNullOrEmpty() && self.activity.time.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.BathTime)
                return false
            }
        case .PottyTraining:
            if self.activity.rating.isNullOrEmpty() && self.activity.time.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.PottyTime)
                return false
            }
        default:
            break
        }
        
        return true
    }
    
    func getSelectedType() {
        if let typeId = activity.type_id {
            switch typeId {
            case "1":
                self.selectedType = .Breakfast
            case "2":
                self.selectedType = .Lunch
            case "3":
                self.selectedType = .Nap
            case "4":
                self.selectedType = .Bathroom
            case "5":
                self.selectedType = .PottyTraining
            default:
                break
            }
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
