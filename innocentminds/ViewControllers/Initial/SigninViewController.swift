//
//  SigninViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/23/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SigninViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var buttonSignin: UIButton!
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupDelegates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func buttonForgotPasswordTapped(_ sender: Any) {
        self.forgotPasswordView.show()
    }
    
    @IBAction func buttonSigninTapped(_ sender: Any) {
        // TODO Dummy
//        if self.textFieldUsername.text == "parent" {
//            self.redirectToVC(storyboardId: StoryboardIds.DashboardNavigationBarController, type: .present)
//        } else if self.textFieldUsername.text == "nurse" {
//            self.redirectToVC(storyboard: nurseStoryboard, storyboardId: StoryboardIds.NurseNavigationController, type: .present)
//        } else if self.textFieldUsername.text == "teacher" {
//            self.redirectToVC(storyboard: teacherStoryboard, storyboardId: StoryboardIds.TeacherNavigationController, type: .present)
//        }
//        return

        if isValidData() {
            self.showLoader()
            
            let username = self.textFieldUsername.text
            let password = self.textFieldPassword.text
            
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.login(email: username!, password: password!)
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue, let json = result?.json?.first {
                        guard let userResponse = UserResponse.init(dictionary: json) else {
                            return
                        }
                        
                        guard let user = userResponse.user else {
                            return
                        }

                        if let roleId = user.role_id {
                            Objects.user = user
                            self.checkUserRole(role: roleId, message: result?.message ?? "")
                            self.saveUserInUserDefaults()
                            self.resetFields()
                        }
                    } else if let message = result?.message, !message.isEmpty {
                        self.showAlertView(message: message, isError: true)
                    } else {
                        self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                    }
                    
                    self.hideLoader()
                }
            }
        } else {
            self.showAlertView(message: errorMessage, isError: true)
        }
    }
    
    func resetFields() {
        self.textFieldUsername.text = nil
        self.textFieldPassword.text = nil
    }
    
    func initializeViews() {
        self.textFieldsView.layer.cornerRadius = Dimensions.cornerRadiusHigh
        self.textFieldsView.layer.borderColor = UIColor.white.cgColor
        self.textFieldsView.layer.borderWidth = 1
        
        self.buttonSignin.layer.cornerRadius = self.buttonSignin.frame.height/2
        self.buttonSubmit.layer.cornerRadius = self.buttonSignin.frame.height/2
        
        self.textFieldEmail.layer.cornerRadius = self.textFieldEmail.frame.height/2
        self.textFieldEmail.layer.borderColor = UIColor.white.cgColor
        self.textFieldEmail.layer.borderWidth = 1

        self.buttonForgotPassword.layer.cornerRadius = self.buttonForgotPassword.frame.height/2
        self.buttonForgotPassword.layer.borderColor = UIColor.white.cgColor
        self.buttonForgotPassword.layer.borderWidth = 1
        self.buttonForgotPassword.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func setupDelegates() {
        self.textFieldEmail.delegate = self
        self.textFieldUsername.delegate = self
        self.textFieldPassword.delegate = self
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        if let email = self.textFieldEmail.text, !email.isEmpty {
            self.showLoader()
            
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.forgotPassword(email: email)
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue {
                        if let message = result?.message {
                            self.showAlertView(message: message)
                        } else {
                            self.showAlertView(message: Localization.string(key: MessageKey.EmailSentPref) + "\( email )" + Localization.string(key: MessageKey.EmailSentSuff))
                        }
                        
                        self.textFieldEmail.text = nil
                    } else if let message = result?.message, !message.isEmpty {
                        self.showAlertView(message: message, isError: true)
                    } else {
                        self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                    }
                    
                    self.hideLoader()
                }
            }
        } else {
            self.showAlertView(message: Localization.string(key: MessageKey.EmailEmpty), isError: true)
        }
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.forgotPasswordView.hide()
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if self.textFieldUsername.text == nil || self.textFieldUsername.text == "" {
            errorMessage = Localization.string(key: MessageKey.UsernameEmpty)
            return false
        }
        if self.textFieldPassword.text == nil || self.textFieldPassword.text == "" {
            errorMessage = Localization.string(key: MessageKey.PasswordEmpty)
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldUsername.isFirstResponder {
            textFieldPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    func checkUserRole(role: String, message: String = "") {
        switch role {
        case UserRole.Parent.rawValue:
            self.redirectToVC(storyboardId: StoryboardIds.DashboardNavigationBarController, type: .present)
        case UserRole.Nurse.rawValue:
            self.redirectToVC(storyboard: nurseStoryboard, storyboardId: StoryboardIds.NurseNavigationController, type: .present)
        case UserRole.Teacher.rawValue, UserRole.TeacherSupervisor.rawValue:
            studentsNotArrived = message.isEmpty ? false : true
            self.redirectToVC(storyboard: teacherStoryboard, storyboardId: StoryboardIds.TeacherNavigationController, type: .present)
        case UserRole.Secretary.rawValue:
            if let registerChildVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.RegisterChildViewController) as? RegisterChildViewController {
                registerChildVC.mode = .add
                self.present(registerChildVC, animated: true, completion: nil)
            }
        default:
            break
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
