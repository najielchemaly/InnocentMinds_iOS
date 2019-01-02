//
//  ChangeChildView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import Kingfisher

class ChangeChildView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonClose: UIButton!
    
    var children: [Child] = [Child]()
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setupTableView(children: [Child]) {
        self.children = children
        
        self.tableView.register(UINib.init(nibName: CellIds.EmptyDataTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyDataTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.ChildTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.ChildTableViewCell)
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.children.count == 0 ? 1 : self.children.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.children.count == 0 ? tableView.frame.height : 170
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.children.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyDataTableViewCell) as? EmptyDataTableViewCell {
                cell.labelTitle.text = Localization.string(key: MessageKey.NoChildren)
                
                return cell
            }
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.ChildTableViewCell) as? ChildTableViewCell {
            cell.selectionStyle = .none
            cell.initializeViews()
            
            let cellTapped = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:)))
            cell.addGestureRecognizer(cellTapped)
            cell.tag = indexPath.section
            
            let child = self.children[indexPath.section]
            if let image = child.image, !image.isEmpty {
                cell.childImageView.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
            } else {
                cell.childImageView.image = #imageLiteral(resourceName: "boy_avatar")
            }
            if let firstName = child.firstname, let lastName = child.lastname {
                cell.labelChildName.text = firstName + " " + lastName
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let cell = sender.view, let dashboardVC = currentVC as? DashboardViewController {
            dashboardVC.selectedChild = self.children[cell.tag]
            dashboardVC.setupChildInfo()
        }
        
        self.hide(remove: true)
    }

}
