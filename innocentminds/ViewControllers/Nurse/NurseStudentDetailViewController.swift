//
//  NurseStudentDetailViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class NurseStudentDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelChildName: UILabel!
    @IBOutlet weak var buttonArrived: UIButton!
    @IBOutlet weak var viewTimeOfArrival: UIView!
    @IBOutlet weak var labelTimeOfArrival: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        self.buttonBack.imageView?.contentMode = .scaleAspectFit
        
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.height/2
        self.imageViewProfile.layer.borderColor = Colors.darkBlue.cgColor
        self.imageViewProfile.layer.borderWidth = 1
        self.imageViewProfile.image = #imageLiteral(resourceName: "avatar_baby")
        
        self.buttonArrived.customizeView()
        
        self.viewTimeOfArrival.layer.cornerRadius = Dimensions.cornerRadiusNormal
        
        self.labelTimeOfArrival.isEnabled(enable: false)
        self.buttonSubmit.isEnabled(enable: false)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.TemperatureTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.TemperatureTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.TemperatureFooterTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.TemperatureFooterTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TemperatureFooterTableViewCell) as? TemperatureFooterTableViewCell {
            cell.selectionStyle = .none
            cell.initializeViews()
            
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(addTemperatureTapped))
            cell.mainView.addGestureRecognizer(cellTap)
            
            return cell
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TemperatureTableViewCell) as? TemperatureTableViewCell{
            cell.selectionStyle = .none
            cell.initializeView()
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func addTemperatureTapped() {
        if let addTemperatureView = self.showView(name: Views.AddTemperatureView) as? AddTemperatureView {
            addTemperatureView.initializeViews()
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func buttonArrivedTapped(_ sender: Any) {
        self.buttonArrived.isSelected = !self.buttonArrived.isSelected
        self.updateButtonArrivedStatus()
    }
    
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        
    }
    
    func updateButtonArrivedStatus() {
        if self.buttonArrived.isSelected {
            self.buttonArrived.layer.borderWidth = 0
            self.buttonArrived.backgroundColor = Colors.selectedGreen
        } else {
            self.buttonArrived.layer.borderWidth = 1
            self.buttonArrived.backgroundColor = .clear
        }
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
