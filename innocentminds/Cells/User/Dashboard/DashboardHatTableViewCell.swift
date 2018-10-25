//
//  DashboardHatTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class DashboardHatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var labelBadge: UILabel!
    @IBOutlet weak var buttonChangeChild: UIButton!
    @IBOutlet weak var labelChildName: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews() {
        self.labelBadge.layer.cornerRadius = self.labelBadge.frame.height/2
        self.childImageView.layer.cornerRadius = self.childImageView.frame.height/2
        
        self.buttonChangeChild.addTarget(self, action: #selector(buttonChangeChildTapped), for: .touchUpInside)
    }
    
    @objc func buttonChangeChildTapped() {
        if let baseVC = currentVC as? BaseViewController {
            if let changeChildView = baseVC.showView(name: Views.ChangeChildView) as? ChangeChildView {
//                changeChildView.setupTableView()
            }
        }
    }
}
