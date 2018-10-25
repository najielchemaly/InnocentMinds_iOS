//
//  EmptyActivityTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class EmptyActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonAddTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            if baseVC is TeacherStudentDetailViewController {
                baseVC.redirectToVC(storyboard: teacherStoryboard, storyboardId: StoryboardIds.AddDailyAgendaViewController, type: .present)
            } else if baseVC is AdditionalActivityViewController {
                baseVC.redirectToVC(storyboard: teacherStoryboard, storyboardId: StoryboardIds.AddAdditionalActivityViewController, type: .present)
            }
        }
    }
    
    func initializeViews() {
        self.selectionStyle = .none
        self.layer.cornerRadius = Dimensions.cornerRadiusNormal
    }
    
}
