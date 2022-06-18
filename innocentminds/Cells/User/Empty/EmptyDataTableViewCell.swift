//
//  EmptyDataTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/24/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class EmptyDataTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonCompleteProfile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.buttonCompleteProfile.customizeBorder(color: Colors.textDark)
        self.buttonCompleteProfile.layer.cornerRadius = self.buttonCompleteProfile.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonCompleteProfileTapped(_ sender: Any) {
        if let dashboardVC = currentVC as? DashboardViewController, let editChildProfileVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.EditChildProfileViewController) as? EditChildProfileViewController {
            editChildProfileVC.selectedChild = dashboardVC.selectedChild
            dashboardVC.present(editChildProfileVC, animated: true, completion: nil)
        }
    }
    
}
