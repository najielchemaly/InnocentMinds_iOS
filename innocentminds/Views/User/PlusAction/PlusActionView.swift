//
//  PlusActionView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class PlusActionView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonClose: UIButton!
    
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
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.MenuTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.MenuTableViewCell)
        self.tableView.layer.cornerRadius = Dimensions.cornerRadiusHigh
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.MenuTableViewCell) as? MenuTableViewCell {
            cell.initializeViews()
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}
