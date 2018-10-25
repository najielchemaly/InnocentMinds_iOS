//
//  MenuTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonAddChild: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        self.buttonAddChild.layer.cornerRadius = Dimensions.cornerRadiusHigh
        self.mainView.layer.cornerRadius = Dimensions.cornerRadiusHigh
    }
    
    @IBAction func buttonAddChildTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.RegisterChildViewController, type: .present)
        }
    }
    
    @IBAction func buttonEditMyProfileTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.EditMyProfileViewController, type: .present)
        }
    }
    
    @IBAction func buttonEditChildProfileTapped(_ sender: Any) {
        
    }
    
    @IBAction func buttonChangeMyPasswordTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.ChangeMyPasswordViewController, type: .present)
        }
    }
    
    @IBAction func buttonSeeImagesTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.GalleryViewController, type: .present)
        }
    }
    
    @IBAction func buttonPaymentTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.PaymentViewController, type: .present)
        }
    }
    
    @IBAction func buttonAboutUsTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.AboutUsViewController, type: .present)
        }
    }
    
    @IBAction func buttonContactUsTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.ContactUsViewController, type: .present)
        }
    }
    
    @IBAction func buttonChangeLanguageTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.SelectLanguageViewController, type: .present)
        }
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.showAlertView(message: Localization.string(key: MessageKey.Logout), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
            
            if let alertView = baseVC.customView as? AlertView {
                alertView.buttonOk.addTarget(baseVC, action: #selector(baseVC.logout), for: .touchUpInside)
            }
        }
    }
    
}
