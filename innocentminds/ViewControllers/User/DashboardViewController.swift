//
//  DashboardViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import Kingfisher

class DashboardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var imageViewMessages: UIImageView!
    @IBOutlet weak var labelBadge: UILabel!
    @IBOutlet weak var labelChildName: UILabel!
    @IBOutlet weak var imageViewChild: UIImageView!
    @IBOutlet weak var buttonChangeChild: UIButton!
    
    var children: [Child] = [Child]()
    var activities: [Activity] = [Activity]()
    var selectedChild: Child = Child()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupChildInfo()
        self.registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonMenuTapped(_ sender: Any) {
        if let plusActionView = self.showView(name: Views.PlusActionView) as? PlusActionView {
            plusActionView.setupTableView()
        }
    }
    
    @IBAction func buttonChangeChildTapped(_ sender: Any) {
        if let changeChildView = self.showView(name: Views.ChangeChildView) as? ChangeChildView {
            changeChildView.setupTableView(children: self.children)
        }
    }
    
    func initializeViews() {
        self.labelBadge.layer.cornerRadius = self.labelBadge.frame.height/2
        self.imageViewChild.layer.cornerRadius = self.imageViewChild.frame.height/2
        
        let messageTap = UITapGestureRecognizer(target: self, action: #selector(messagesTapped))
        self.imageViewMessages.addGestureRecognizer(messageTap)
        
        if let children = currentUser.children {
            self.children = children
        }
        if let child = self.children.first {
            self.selectedChild = child
        }
        
        self.setupChildInfo()
    }
    
    func setupChildInfo(reload: Bool = false) {
        if let image = self.selectedChild.image {
            self.imageViewChild.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
        }
        if let firstName = self.selectedChild.firstname, let lastName = self.selectedChild.lastname {
            self.labelChildName.text = firstName + " " + lastName
        }
        
        if let activities = self.selectedChild.activities {
            self.activities = activities
        }
        
        if reload {
            self.tableView.reloadData()
        }
    }
    
    func registerCells() {
        self.tableView.register(UINib.init(nibName: CellIds.EmptyDataTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyDataTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.DashboardPostTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.DashboardPostTableViewCell)
        
        self.tableView.tableFooterView = UIView()
    }
    
    @objc func messagesTapped() {
        if let messagesView = self.showView(name: Views.MessagesView) as? MessagesView {
            messagesView.initializeViews()
            messagesView.setupTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count == 0 ? 1 : self.activities.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.activities.count == 0 ? tableView.frame.height :
        indexPath.row == self.activities.count-1 ? 70 : 170
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.activities.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyDataTableViewCell) as? EmptyDataTableViewCell {
                cell.labelTitle.text = Localization.string(key: MessageKey.NoDashboard)
                cell.labelTitle.textColor = Colors.textDark
                
                return cell
            }
        } else {
            if indexPath.row == self.activities.count-1 {
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.DashboardPostTableViewCell) as? DashboardPostTableViewCell {
                cell.selectionStyle = .none
                cell.initializeViews()
                cell.disableStars()
                
                let activity = self.activities[indexPath.row]
                if let type = activity.type_id {
                    switch type {
                    case ActivityType.Breakfast.rawValue,
                         ActivityType.Lunch.rawValue:
                        cell.typeView.backgroundColor = Colors.appOrange
                        cell.labelTitle.textColor = Colors.appOrange
                        cell.typeImageView.image = #imageLiteral(resourceName: "food_icon")
                    case ActivityType.Nap.rawValue:
                        cell.typeView.backgroundColor = Colors.appBlue
                        cell.labelTitle.textColor = Colors.appBlue
                        cell.typeImageView.image = #imageLiteral(resourceName: "nap_icon")
                    case ActivityType.Bathroom.rawValue,
                         ActivityType.PottyTraining.rawValue:
                        cell.typeView.backgroundColor = Colors.appGreen
                        cell.labelTitle.textColor = Colors.appGreen
                        cell.typeImageView.image = #imageLiteral(resourceName: "bath_icon")
                    case ActivityType.Additional.rawValue:
                        cell.buttonViewImages.isHidden = false
                        cell.typeView.backgroundColor = Colors.appPurple
                        cell.labelTitle.textColor = Colors.appPurple
                        cell.typeImageView.image = #imageLiteral(resourceName: "outing_icon")
                    default:
                        break
                    }
                }
                
                cell.labelTitle.text = activity.title
                cell.labelDescription.text = activity.description
                
                return cell
            }
        }
        
        return UITableViewCell()
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
