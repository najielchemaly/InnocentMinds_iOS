//
//  NurseStudentTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/3/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class TeacherStudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelStudentName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        self.selectionStyle = .none
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.height/2
    }
    
}
