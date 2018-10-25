//
//  ViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/22/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class InitialViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
}

