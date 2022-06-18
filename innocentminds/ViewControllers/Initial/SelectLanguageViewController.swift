//
//  SelectLanguageViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/2/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SelectLanguageViewController: BaseViewController {

    @IBOutlet weak var buttonEnglish: UIButton!
    @IBOutlet weak var buttonFrench: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var isInitial: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.buttonEnglish.layer.cornerRadius = self.buttonEnglish.frame.height/2
        self.buttonFrench.layer.cornerRadius = self.buttonEnglish.frame.height/2
        
        if currentVC is DashboardViewController {
            self.buttonCancel.isHidden = false
            self.isInitial = false
            
            let currentLanguage = Localization.currentLanguage()
            switch currentLanguage.lowercased() {
            case "en":
                self.buttonEnglish.isSelected = true
                self.buttonEnglish.backgroundColor = Colors.appGreen
            case "fr":
                self.buttonFrench.isSelected = true
                self.buttonFrench.backgroundColor = Colors.appGreen
            default:
                break
            }
        }
    }
    
    @IBAction func buttonLanguageTapped(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        if button.isSelected { return }
        
        self.buttonEnglish.isSelected = false
        self.buttonFrench.isSelected = false
        
        if let button = sender as? UIButton {
            button.isSelected = !button.isSelected
        }
        
        self.buttonEnglish.backgroundColor = self.buttonEnglish.isSelected ? Colors.appGreen : Colors.appGray
        self.buttonFrench.backgroundColor = self.buttonFrench.isSelected ? Colors.appGreen : Colors.appGray
        
        UserDefaults.standard.set(true, forKey: "didSelectLanguage")
        
        Localization.setLanguageTo(self.buttonEnglish.isSelected ? "en" : "fr")
        
        self.showLoader(message: Localization.string(key: MessageKey.SettingLanguage))
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
            if self.isInitial {
                if let mainNavigationController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIds.MainNavigationController) as? UINavigationController {
                    appDelegate.window?.rootViewController = mainNavigationController
                }
            } else {
                if let dashboardNavigationController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIds.DashboardNavigationBarController) as? UINavigationController {
                    appDelegate.window?.rootViewController = dashboardNavigationController
                }
            }
            
            self.hideLoader()
        })
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
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
