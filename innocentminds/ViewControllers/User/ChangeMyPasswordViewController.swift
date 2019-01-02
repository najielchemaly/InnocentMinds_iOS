//
//  ChangeMyPasswordViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/28/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class ChangeMyPasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var textFieldOldPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showLoader()
            
            let userId = Objects.user.id ?? "0"
            let oldPassword = self.textFieldOldPassword.text ?? ""
            let newPassword = self.textFieldNewPassword.text ?? ""
            
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.changePassword(id: userId, oldPassword: oldPassword, newPassword: newPassword)
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue {
                        if let message = result?.message {
                            self.showAlertView(message: message, dismiss: true)
                        } else {
                            self.showAlertView(message: Localization.string(key: MessageKey.ChangePassword), dismiss: true)
                        }
                    } else if let message = result?.message {
                        self.showAlertView(message: message, isError: true)
                    } else {
                        self.showAlertView(message: Localization.string(key: MessageKey.ChangePassword), isError: true)
                    }
                    
                    self.hideLoader()
                }
            }
        } else {
            self.showAlertView(message: errorMessage, isError: true)
        }
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    func initializeViews() {
        self.textFieldsView.layer.cornerRadius = Dimensions.cornerRadiusHigh
        self.textFieldsView.layer.borderColor = UIColor.white.cgColor
        self.textFieldsView.layer.borderWidth = 1
        
        self.buttonSave.layer.cornerRadius = self.buttonSave.frame.height/2
        self.buttonSave.layer.cornerRadius = self.buttonSave.frame.height/2
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if self.textFieldOldPassword.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.PasswordEmpty)
            return false
        } else if self.textFieldNewPassword.text.isNullOrEmpty() {
            errorMessage = Localization.string(key: MessageKey.NewPasswordEmpty)
            return false
        } else if self.textFieldNewPassword.text != self.textFieldConfirmPassword.text {
            errorMessage = Localization.string(key: MessageKey.PasswordNotMatch)
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.textFieldOldPassword.isFirstResponder {
            self.textFieldNewPassword.becomeFirstResponder()
        } else if self.textFieldNewPassword.isFirstResponder {
            self.textFieldConfirmPassword.becomeFirstResponder()
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
