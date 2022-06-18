//
//  SendUsMessageView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/30/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SendUsMessageView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewFirstName: UIView!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewBranch: UIView!
    @IBOutlet weak var viewInquiry: UIView!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldBranch: UITextField!
    @IBOutlet weak var buttonBranch: UIButton!
    @IBOutlet weak var textViewInquiry: UITextView!
    @IBOutlet weak var viewConfirmEmail: UIView!
    @IBOutlet weak var textFieldConfirmEmail: UITextField!
    
    var pickerView: UIPickerView!
    var branches: [Branch] = [Branch]()
    var selectedBranchId: String? = ""
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
    func initializeViews() {        
        self.viewFirstName.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewLastName.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewEmail.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewConfirmEmail.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewPhoneNumber.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewBranch.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.viewInquiry.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonSend.layer.cornerRadius = self.buttonSend.frame.height/2
        
        self.buttonSend.addTarget(self, action: #selector(buttonSendTapped(sender:)), for: .touchUpInside)
        
        if let branches = Objects.variables.branches {
            self.branches = branches
        }
        
        self.setupPickerViews()
        self.setupTextFieldsDelegates()
    }
    
    func setupPickerViews() {
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.textFieldBranch.inputView = self.pickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Cancel), style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        cancelButton.tintColor = Colors.appBlue
        let doneButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Done), style: .plain, target: self, action: #selector(self.doneButtonTapped))
        doneButton.tintColor = Colors.appBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        
        self.textFieldBranch.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.branches.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.branches[row].title
    }
    
    @objc func cancelButtonTapped() {
        textFieldBranch.resignFirstResponder()
    }
    
    @objc func doneButtonTapped() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.textFieldBranch.text = self.branches[row].title
        self.selectedBranchId = self.branches[row].id

        textFieldBranch.resignFirstResponder()
    }
    
    @objc func buttonSendTapped(sender: UIButton) {
        if let baseVC = currentVC as? BaseViewController {
            if isValidData() {
                baseVC.showLoader()
                
                let firstName = self.textFieldFirstName.text!
                let lastName = self.textFieldLastName.text!
                let email = self.textFieldEmail.text!
                let phone = self.textFieldPhoneNumber.text!
                let branchId = self.textFieldBranch.text!
                let inquiry = self.textViewInquiry.text!
                
                DispatchQueue.global(qos: .background).async {
                    let result = appDelegate.services.sendContactUs(firstName: firstName, lastName: lastName, email: email, phone: phone, branchId: branchId, inquiry: inquiry)
                    
                    DispatchQueue.main.async {
                        if result?.status == ResponseStatus.SUCCESS.rawValue {
                            if let message = result?.message {
                                baseVC.showAlertView(message: message)
                            } else {
                                baseVC.showAlertView(message: Localization.string(key: MessageKey.SendContactUs))
                            }
                            
                            self.resetFields()
                        } else if let message = result?.message {
                            baseVC.showAlertView(message: message, isError: true)
                        } else {
                            baseVC.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                        }
                        
                        baseVC.hideLoader()
                    }
                }
            } else {
                baseVC.showAlertView(message: errorMessage, isError: true)
            }
        }
    }
    
    func setupTextFieldsDelegates() {
        self.textFieldFirstName.delegate = self
        self.textFieldLastName.delegate = self
        self.textFieldEmail.delegate = self
        self.textFieldConfirmEmail.delegate = self
        self.textFieldPhoneNumber.delegate = self
        self.textFieldBranch.delegate = self
        self.textViewInquiry.delegate = self
    }
    
    func resetFields() {
        self.textFieldFirstName.text = nil
        self.textFieldLastName.text = nil
        self.textFieldPhoneNumber.text = nil
        self.textFieldEmail.text = nil
        self.textFieldBranch.text = nil
        self.textViewInquiry.text = nil
    }
    
    var errorMessage: String = Localization.string(key: MessageKey.MissingInfo)
    func isValidData() -> Bool {
        self.resetError()
        
        var isValid = true
        
        if self.textFieldFirstName.text.isNullOrEmpty() {
            self.viewFirstName.showError()
//            errorMessage = Localization.string(key: MessageKey.FirstNameEmpty)
            isValid = false
        }
        if self.textFieldLastName.text.isNullOrEmpty() {
            self.viewLastName.showError()
//            errorMessage = Localization.string(key: MessageKey.LastNameEmpty)
            isValid = false
        }
        if let phoneText = self.textFieldPhoneNumber.text {
            if !phoneText.isValidPhoneNumber() {
//            errorMessage = Localization.string(key: MessageKey.PhoneEmpty)
                self.viewPhoneNumber.showError()
                isValid = false
            }
        }
        if let emailText = self.textFieldEmail.text {
            if !emailText.isValidEmail() {
//            errorMessage = Localization.string(key: MessageKey.EmailEmpty)
                self.viewEmail.showError()
                isValid = false
            }
        }
        if self.textFieldConfirmEmail.text.isNullOrEmpty() ||
           self.textFieldConfirmEmail.text != self.textFieldEmail.text {
            self.viewConfirmEmail.showError()
            //            errorMessage = Localization.string(key: MessageKey.EmailEmpty)
            isValid = false
        }
        if self.textFieldBranch.text.isNullOrEmpty() {
            self.viewBranch.showError()
//            errorMessage = Localization.string(key: MessageKey.BranchEmpty)
            isValid = false
        }
        if self.textViewInquiry.text == nil || self.textViewInquiry.text == "" {
            self.viewInquiry.showError()
//            errorMessage = Localization.string(key: MessageKey.InquiryEmpty)
            isValid = false
        }
        
        return isValid
    }
    
    func resetError() {
        self.viewFirstName.hideError()
        self.viewLastName.hideError()
        self.viewPhoneNumber.hideError()
        self.viewEmail.hideError()
        self.viewConfirmEmail.hideError()
        self.viewBranch.hideError()
        self.viewInquiry.hideError()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let view = textField.superview else {
            return false
        }
        view.hideError()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let view = textView.superview else {
            return false
        }
        view.hideError()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldFirstName.isFirstResponder {
            textFieldLastName.becomeFirstResponder()
        } else if textFieldLastName.isFirstResponder {
            textFieldEmail.becomeFirstResponder()
        } else if textFieldEmail.isFirstResponder {
            textFieldConfirmEmail.becomeFirstResponder()
        } else if textFieldConfirmEmail.isFirstResponder {
            textFieldPhoneNumber.becomeFirstResponder()
        } else if textFieldPhoneNumber.isFirstResponder {
            textFieldBranch.becomeFirstResponder()
        } else if textFieldBranch.isFirstResponder {
            textViewInquiry.becomeFirstResponder()
        }
        
        return true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
