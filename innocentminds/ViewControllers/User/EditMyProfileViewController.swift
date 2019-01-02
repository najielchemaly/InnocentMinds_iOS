//
//  EditMyProfileViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/28/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class EditMyProfileViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewTextFields: UIView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showLoader()
            
            let id = Objects.user.id ?? "0"
            let fullname = self.textFieldName.text ?? ""
            let phone = self.textFieldPhone.text ?? ""
            let email = self.textFieldEmail.text ?? ""
            let address = self.textFieldAddress.text ?? ""
            
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.editProfile(id: id, fullname: fullname, phoneNumber: phone, email: email, address: address)
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue {
                        if let message = result?.message {
                            self.showAlertView(message: message, dismiss: true)
                        } else {
                            self.showAlertView(message: Localization.string(key: MessageKey.EditProfile), dismiss: true)
                        }
                    } else {
                        if let message = result?.message {
                            self.showAlertView(message: message, isError: true)
                        } else {
                            self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                        }
                    }
                    
                    self.hideLoader()
                }
            }
        } else {
            self.showAlertView(message: errorMessage, isError: true)
        }
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    func initializeViews() {
        self.viewTextFields.layer.cornerRadius = Dimensions.cornerRadiusHigh
        self.viewTextFields.layer.borderColor = UIColor.white.cgColor
        self.viewTextFields.layer.borderWidth = 1
        
        self.buttonSave.layer.cornerRadius = self.buttonSave.frame.height/2
        self.buttonSave.layer.cornerRadius = self.buttonSave.frame.height/2
    }
    
    func setupUserInfo() {
        self.textFieldName.text = Objects.user.fullname
        self.textFieldPhone.text = Objects.user.phone
        self.textFieldEmail.text = Objects.user.email
        self.textFieldAddress.text = Objects.user.address
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if self.textFieldName.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.NameEmpty)
            return false
        } else if self.textFieldPhone.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.PhoneEmpty)
            return false
        } else if self.textFieldEmail.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.EmailEmpty)
            return false
        } else if self.textFieldAddress.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.AddressEmpty)
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFieldName.isFirstResponder {
            self.textFieldPhone.becomeFirstResponder()
        } else if self.textFieldPhone.isFirstResponder {
            self.textFieldEmail.becomeFirstResponder()
        } else if self.textFieldEmail.isFirstResponder {
            self.textFieldAddress.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
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
