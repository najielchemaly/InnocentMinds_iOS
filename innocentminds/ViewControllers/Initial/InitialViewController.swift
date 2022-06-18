//
//  ViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/22/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class InitialViewController: BaseViewController {
    
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var buttonSignin: UIButton!
    @IBOutlet weak var buttonGuest: UIButton!
    @IBOutlet weak var buttonSwitchLanguage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initializeViews() {
        self.buttonRegister.setImage(Localization.currentLanguage() == "en" ? UIImage(named: "pick_user_register_full") : UIImage(named: "pick_user_register_full_fr"), for: .normal)
        
        self.buttonSignin.setImage(Localization.currentLanguage() == "en" ? UIImage(named: "pick_user_signin_full") : UIImage(named: "pick_user_signin_full_fr"), for: .normal)
        
        self.buttonGuest.setImage(Localization.currentLanguage() == "en" ? UIImage(named: "pick_user_guest_full") : UIImage(named: "pick_user_guest_full_fr"), for: .normal)
        
        self.setButtonSwitchLanguageTitle()
        
    }
    
    func setButtonSwitchLanguageTitle() {
        let language = Localization.currentLanguage() == "en" ? "Fr" : "En"
        self.buttonSwitchLanguage.setTitle(language, for: .normal)
    }
    
    @IBAction func buttonRegisterTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.RegisterChildViewController, type: .present)
    }
    
    @IBAction func buttonSigninTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.SigninViewController, type: .present)
    }
    
    @IBAction func buttonGuestTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.GuestTabBarViewController, type: .present)
    }
    
    @IBAction func buttonSwitchLanguageTapped(_ sender: Any) {
        let lang = Localization.currentLanguage() == "en" ? "fr" : "en"
        Localization.setLanguageTo(lang)
        
        if let mainNavigationController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIds.MainNavigationController) as? UINavigationController {
            appDelegate.window?.rootViewController = mainNavigationController
        }
    
    }
}

