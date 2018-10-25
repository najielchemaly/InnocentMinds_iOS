//
//  PersonalInformationCollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/12/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class PersonalInformationCollectionViewCell: FSPagerViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var buttonAddImage: UIButton!
    @IBOutlet weak var buttonChangeImage: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var textFieldFirstname: UITextField!
    @IBOutlet weak var textFieldFathername: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var textFieldGender: UITextField!
    @IBOutlet weak var textFieldDateOfBirth: UITextField!
    @IBOutlet weak var textFieldPlaceOfBirth: UITextField!
    @IBOutlet weak var textFieldHomeLanguage: UITextField!
    @IBOutlet weak var textFieldProgramLanguage: UITextField!
    @IBOutlet weak var textFieldTransportation: UITextField!

    var datePicker: UIDatePicker!
    var pickerView: UIPickerView!
    
    var genders: [Gender] = [Gender]()
    var homeLanguages: [HomeLanguage] = [HomeLanguage]()
    var programLanguages: [ProgramLanguage] = [ProgramLanguage]()
    var transportations: [Transportation] = [Transportation]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeViews() {
        self.contentView.layer.shadowRadius = 0
        
        self.buttonAddImage.customizeView(width: self.buttonAddImage.frame.height/2)
        
        for view in self.stackView.subviews {
            view.customizeView()
        }
        
        // TESTING
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
            if self.genders.count == 0 {
                self.setupPickerData()
            } else {
                timer.invalidate()
            }
        })
        
        self.setupDelegates()
        self.setupPickerViews()
    }
    
    func setupPickerData() {
        if let genders = Objects.variables.genders {
            self.genders = genders
        }
        if let homeLanguages = Objects.variables.home_languages {
            self.homeLanguages = homeLanguages
        }
        if let programLanguages = Objects.variables.program_languages {
            self.programLanguages = programLanguages
        }
        if let transportations = Objects.variables.transportations {
            self.transportations = transportations
        }
    }
    
    func setupDelegates() {
        self.textFieldGender.delegate = self
        self.textFieldFathername.delegate = self
        self.textFieldLastname.delegate = self
        self.textFieldPlaceOfBirth.delegate = self
    }
    
    func setupPickerViews() {
        if let baseVC = currentVC as? BaseViewController {
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            
            self.textFieldGender.inputView = self.pickerView
            self.textFieldHomeLanguage.inputView = self.pickerView
            self.textFieldProgramLanguage.inputView = self.pickerView
            self.textFieldTransportation.inputView = self.pickerView
            
            self.datePicker = UIDatePicker()
            self.datePicker.datePickerMode = .date
            self.textFieldDateOfBirth.inputView = self.datePicker
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: baseVC.view.frame.width, height: 44))
            toolbar.sizeToFit()
            toolbar.barStyle = .default
            let cancelButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Cancel), style: .plain, target: baseVC, action: #selector(baseVC.dismissKeyboard))
            cancelButton.tintColor = Colors.appBlue
            let doneButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Done), style: .plain, target: self, action: #selector(self.doneButtonTapped))
            doneButton.tintColor = Colors.appBlue
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            toolbar.items = [cancelButton, flexibleSpace, doneButton]
            
            self.textFieldGender.inputAccessoryView = toolbar
            self.textFieldHomeLanguage.inputAccessoryView = toolbar
            self.textFieldProgramLanguage.inputAccessoryView = toolbar
            self.textFieldTransportation.inputAccessoryView = toolbar
            self.textFieldDateOfBirth.inputAccessoryView = toolbar
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.textFieldGender.isFirstResponder {
            return self.genders.count
        } else if self.textFieldHomeLanguage.isFirstResponder {
            return self.homeLanguages.count
        } else if self.textFieldProgramLanguage.isFirstResponder {
            return self.programLanguages.count
        } else if self.textFieldTransportation.isFirstResponder {
            return self.transportations.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.textFieldGender.isFirstResponder {
            return self.genders[row].title
        } else if self.textFieldHomeLanguage.isFirstResponder {
            return self.homeLanguages[row].title
        } else if self.textFieldProgramLanguage.isFirstResponder {
            return self.programLanguages[row].title
        } else if self.textFieldTransportation.isFirstResponder {
            return self.transportations[row].title
        }
        
        return nil
    }
    
    @objc func doneButtonTapped() {
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            let row = self.pickerView.selectedRow(inComponent: 0)
            if self.textFieldGender.isFirstResponder {
                self.textFieldGender.text = self.genders[row].title
                editChildProfileVC.selectedChild.gender_id = self.genders[row].id
            } else if self.textFieldHomeLanguage.isFirstResponder {
                self.textFieldHomeLanguage.text = self.homeLanguages[row].title
                editChildProfileVC.selectedChild.home_language_id = self.homeLanguages[row].id
            } else if self.textFieldProgramLanguage.isFirstResponder {
                self.textFieldProgramLanguage.text = self.programLanguages[row].title
                editChildProfileVC.selectedChild.desired_language_id = self.programLanguages[row].id
            } else if self.textFieldTransportation.isFirstResponder {
                self.textFieldTransportation.text = self.transportations[row].title
                editChildProfileVC.selectedChild.transp_id = self.transportations[row].id
            } else {
                self.handleDatePicker()
            }
            
            editChildProfileVC.dismissKeyboard()
        }
    }
    
    func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.textFieldDateOfBirth.text = dateFormatter.string(from: self.datePicker.date)
        
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            editChildProfileVC.selectedChild.date_of_birth = self.textFieldDateOfBirth.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFieldFirstname.isFirstResponder {
            self.textFieldFathername.becomeFirstResponder()
        } else if self.textFieldFathername.isFirstResponder {
            self.textFieldLastname.becomeFirstResponder()
        } else if self.textFieldLastname.isFirstResponder {
            self.textFieldGender.becomeFirstResponder()
        } else if self.textFieldPlaceOfBirth.isFirstResponder {
            self.textFieldHomeLanguage.becomeFirstResponder()
        } else if let baseVC = currentVC as? BaseViewController {
            baseVC.dismissKeyboard()
        }
        
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            if self.textFieldFirstname.isFirstResponder {
                editChildProfileVC.selectedChild.firstname = self.textFieldFirstname.text
            } else if self.textFieldFathername.isFirstResponder {
                editChildProfileVC.selectedChild.fathername = self.textFieldFathername.text
            } else if self.textFieldLastname.isFirstResponder {
                editChildProfileVC.selectedChild.lastname = self.textFieldLastname.text
            } else if self.textFieldPlaceOfBirth.isFirstResponder {
                editChildProfileVC.selectedChild.place_of_birth = self.textFieldPlaceOfBirth.text
            }
        }
        
        return true
    }
    
}
