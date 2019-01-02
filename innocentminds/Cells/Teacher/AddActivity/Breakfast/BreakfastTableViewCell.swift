//
//  BreakfastTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class BreakfastTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonStar1: UIButton!
    @IBOutlet weak var buttonStar2: UIButton!
    @IBOutlet weak var buttonStar3: UIButton!
    @IBOutlet weak var buttonStar4: UIButton!
    @IBOutlet weak var buttonSad: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    let placeholder: String = "Add text"
    
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
        self.layer.cornerRadius = Dimensions.cornerRadiusNormal
        
        self.buttonStar1.imageView?.contentMode = .scaleAspectFit
        self.buttonStar2.imageView?.contentMode = .scaleAspectFit
        self.buttonStar3.imageView?.contentMode = .scaleAspectFit
        self.buttonStar4.imageView?.contentMode = .scaleAspectFit
        
        self.textView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholder {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == nil || textView.text == "" {
            textView.text = self.placeholder
        }
    }
    
}
