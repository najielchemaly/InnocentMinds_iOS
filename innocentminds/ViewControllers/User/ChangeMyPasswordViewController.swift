//
//  ChangeMyPasswordViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/28/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class ChangeMyPasswordViewController: BaseViewController {

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
        self.showAlertView(title: "Change password", message: "Your password has been changed successfully")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
