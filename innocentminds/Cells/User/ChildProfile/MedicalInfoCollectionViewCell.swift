//
//  MedicalInfoCollectionViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/13/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class MedicalInfoCollectionViewCell: FSPagerViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldBloodType: UITextField!
    @IBOutlet weak var textFieldAllergy: UITextField!
    @IBOutlet weak var textViewAllergy: UITextView!
    @IBOutlet weak var textFieldRegularMedications: UITextField!
    @IBOutlet weak var textViewRegularMedications: UITextView!
    @IBOutlet weak var buttonDesease: UIButton!
    @IBOutlet weak var textViewSpecialMedicalConditions: UITextView!
    @IBOutlet weak var viewAllergy: UIView!
    @IBOutlet weak var viewRegularMedication: UITextView!
    
    var bloodTypes: [BloodType] = [BloodType]()
    
    var pickerView: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeViews() {
        self.contentView.layer.shadowRadius = 0
        
        for view in self.scrollView.subviews {
            view.customizeView()
        }
        
        if let bloodTypes = Objects.variables.blood_types {
            self.bloodTypes = bloodTypes
        }
        
        self.setupDelegates()
        self.setupPickerViews()
    }
    
    func setupDelegates() {
        self.textViewAllergy.delegate = self
        self.textViewRegularMedications.delegate = self
        self.textViewSpecialMedicalConditions.delegate = self
    }
    
    func setupPickerViews() {
        if let baseVC = currentVC as? BaseViewController {
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            
            self.textFieldBloodType.inputView = self.pickerView
            self.textFieldAllergy.inputView = self.pickerView
            self.textFieldRegularMedications.inputView = self.pickerView
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: baseVC.view.frame.width, height: 44))
            toolbar.sizeToFit()
            toolbar.barStyle = .default
            let cancelButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Cancel), style: .plain, target: baseVC, action: #selector(baseVC.dismissKeyboard))
            cancelButton.tintColor = Colors.appBlue
            let doneButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Done), style: .plain, target: self, action: #selector(self.doneButtonTapped))
            doneButton.tintColor = Colors.appBlue
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            toolbar.items = [cancelButton, flexibleSpace, doneButton]
            
            self.textFieldBloodType.inputAccessoryView = toolbar
            self.textFieldAllergy.inputAccessoryView = toolbar
            self.textFieldRegularMedications.inputAccessoryView = toolbar
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.textFieldBloodType.isFirstResponder {
            return self.bloodTypes.count
        } else {
            return Objects.answers.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.textFieldBloodType.isFirstResponder {
            return self.bloodTypes[row].title
        } else {
            return Objects.answers[row]
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.pickerView.selectRow(0, inComponent: 0, animated: false)
        
        return true
    }
    
    @objc func doneButtonTapped() {
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            let row = self.pickerView.selectedRow(inComponent: 0)
            if self.textFieldBloodType.isFirstResponder {
                self.textFieldBloodType.text = self.bloodTypes[row].title
                editChildProfileVC.selectedChild.blood_type_id = self.bloodTypes[row].id
            } else if self.textFieldAllergy.isFirstResponder {
                let allergy = editChildProfileVC.selectedChild.allergy.isNullOrEmpty() ? Localization.string(key: MessageKey.SpecifyAllergy) : editChildProfileVC.selectedChild.allergy
                self.textFieldAllergy.text = Objects.answers[row]
                self.textViewAllergy.isEnabled(enable: self.textFieldAllergy.text == "Yes")
                self.viewAllergy.isEnabled(enable: self.textFieldAllergy.text == "Yes")
                self.textViewAllergy.text = self.textFieldAllergy.text == "Yes" ? allergy : Localization.string(key: MessageKey.SpecifyAllergy)
                
                if self.textFieldAllergy.text == "No" {
                    editChildProfileVC.selectedChild.allergy = nil
                }
            } else if self.textFieldRegularMedications.isFirstResponder {
                let medications = editChildProfileVC.selectedChild.regular_medication.isNullOrEmpty() ? Localization.string(key: MessageKey.SpecifyMedications) : editChildProfileVC.selectedChild.regular_medication
                self.textFieldRegularMedications.text = Objects.answers[row]
                self.textViewRegularMedications.isEnabled(enable: self.textFieldRegularMedications.text == "Yes")
                self.viewRegularMedication.isEnabled(enable: self.textFieldRegularMedications.text == "Yes")
                self.textViewRegularMedications.text = self.textFieldRegularMedications.text == "Yes" ? medications : Localization.string(key: MessageKey.SpecifyMedications)
                
                if self.textFieldRegularMedications.text == "No" {
                    editChildProfileVC.selectedChild.regular_medication = nil
                }
            }
        
            editChildProfileVC.dismissKeyboard()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            if self.textViewAllergy.isFirstResponder {
                editChildProfileVC.selectedChild.allergy = self.textViewAllergy.text ?? "" + text
            } else if self.textViewRegularMedications.isFirstResponder {
                editChildProfileVC.selectedChild.regular_medication = self.textViewRegularMedications.text ?? "" + text
            } else if self.textViewSpecialMedicalConditions.isFirstResponder {
                editChildProfileVC.selectedChild.special_medical_conditions = self.textViewSpecialMedicalConditions.text ?? "" + text
            }
        }
        
        return true
    }

    @IBAction func buttonDiseaseTapped(_ sender: Any) {
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            if let diseaseView = editChildProfileVC.showView(name: Views.DiseaseView) as? DiseaseView {
                diseaseView.initializeViews(diseaseIds: editChildProfileVC.selectedChild.disease_ids ?? "")
            }
        }
    }
    
}
