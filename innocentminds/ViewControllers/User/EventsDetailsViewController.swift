//
//  CalendarDetailsViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 2/9/19.
//  Copyright © 2019 infosys. All rights reserved.
//

import UIKit

class EventsDetailsViewController: BaseViewController {

    @IBOutlet weak var imageViewTop: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelViewTitle: UILabel!
    
    var selectedEvent: Event!
    var viewTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    func initializeViews() {
        if let event = self.selectedEvent {
            self.labelViewTitle.text = self.viewTitle
            
            self.labelTitle.text = event.title
            self.labelDate.text = event.date
            self.labelTime.text = event.time
            self.labelDescription.text = event.description
            
            if let data = event.image,
                let image = UIImage(data: data) {
                self.imageViewTop.image = image
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
