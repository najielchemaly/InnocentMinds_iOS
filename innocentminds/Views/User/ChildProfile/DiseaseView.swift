//
//  DiseaseView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/13/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class DiseaseView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    var diseases: [Disease] = [Disease]()
    var selectedDiseaseIds: [String] = [String]()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
    func initializeViews() {
        if let diseases = Objects.variables.diseases {
            self.diseases = diseases
        }
        
        self.buttonConfirm.layer.cornerRadius = self.buttonConfirm.frame.height/2
        
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.DiseaseTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.DiseaseTableViewCell)
        self.tableView.tableFooterView = UIView()
        
        self.tableView.layer.cornerRadius = Dimensions.cornerRadiusHigh
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diseases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.DiseaseTableViewCell) as? DiseaseTableViewCell {
            cell.initializeViews()
            
            let disease = self.diseases[indexPath.row]
            if let title = disease.title {
                cell.buttonTitle.setTitle(title, for: .normal)
            }
            
            if let id = disease.id {
                cell.buttonTitle.isSelected = self.selectedDiseaseIds.contains(id)
                cell.imageViewCheck.image = self.selectedDiseaseIds.contains(id) ? #imageLiteral(resourceName: "checked_icon") : #imageLiteral(resourceName: "unchecked_icon")
            }
            
            cell.buttonTitle.addTarget(self, action: #selector(buttonTitleTapped(sender:)), for: .touchUpInside)
            cell.buttonTitle.tag = indexPath.row
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func buttonTitleTapped(sender: UIButton) {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? DiseaseTableViewCell {
            let disease = self.diseases[sender.tag]
            if let id = disease.id {
                if self.selectedDiseaseIds.contains(id) {
                    if let index = self.selectedDiseaseIds.index(of: id) {
                        self.selectedDiseaseIds.remove(at: index)
                    }
                    
                    cell.buttonTitle.isSelected = false
                    cell.imageViewCheck.image = #imageLiteral(resourceName: "unchecked_icon")
                } else {
                    self.selectedDiseaseIds.append(id)
                    
                    cell.buttonTitle.isSelected = true
                    cell.imageViewCheck.image = #imageLiteral(resourceName: "checked_icon")
                }
            }
        }
    }
    
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
}
