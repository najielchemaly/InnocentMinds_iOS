//
//  EditMyProfileViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/28/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class EditMyProfileViewController: BaseViewController {
    
    @IBOutlet weak var viewTextFields: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
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
        self.showAlertView(title: "Edit profile", message: "Your profile has been updated successfully")
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
//        self.textFieldEmail.text = currentUser.email
//        self.textFieldUsername.text = currentUser.username
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
