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
    @IBOutlet weak var viewChildInfo: UIView!
    
    var children: [Child] = [Child]()
    var activities: [Activity] = [Activity]()
    var selectedChild: Child = Child()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appDelegate.registerForRemoteNotifications()
        
        self.initializeViews()
        self.setupChildInfo()
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let firebase_token = UserDefaults.standard.string(forKey: "firebase_token") {
            Objects.user.firebase_token = firebase_token
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonMenuTapped(_ sender: Any) {
        if let plusActionView = self.showView(name: Views.PlusActionView, fromWindow: false) as? PlusActionView {
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
        
        self.setNotificationBadgeNumber(label: self.labelBadge)
        
        let messageTap = UITapGestureRecognizer(target: self, action: #selector(messagesTapped))
        self.imageViewMessages.addGestureRecognizer(messageTap)
    }
    
    func setupChildInfo() {
        if let children = Objects.user.children {
            self.children = children
        }
        
        if let childId = self.selectedChild.id {
            let filteredChildren = self.children.filter { $0.id == childId }
            if let child = filteredChildren.first {
                self.selectedChild = child
            }
        } else if let child = self.children.first {
            self.selectedChild = child
        }
        
        if let activities = self.selectedChild.activities {
            self.activities = activities
        }
        
        if let image = self.selectedChild.image, !image.isEmpty {
            self.imageViewChild.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
        }
        
        if let firstName = self.selectedChild.firstname, let lastName = self.selectedChild.lastname {
            self.labelChildName.text = firstName + " " + lastName
        }
        
        self.viewChildInfo.isHidden = self.selectedChild.id.isNullOrEmpty()
        
        self.tableView.reloadData()
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.EmptyDataTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyDataTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.DashboardPostTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.DashboardPostTableViewCell)
        
        self.tableView.tableFooterView = UIView()
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    @objc func handleRefresh() {
        let userId = Objects.user.id ?? "0"
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.getParentChildren(userId: userId)
            
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue,
                    let jsonArray = result?.json?.first?["children"] as? [NSDictionary] {
                    Objects.user.children = [Child]()
                    for json in jsonArray {
                        guard let child = Child.init(dictionary: json) else {
                            return
                        }
                        
                        Objects.user.children?.append(child)
                    }
                    
                    self.setupChildInfo()
                }
                
                self.refreshControl.endRefreshing()
            }
        }
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
            indexPath.row == self.activities.count ? 70 : 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.activities.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyDataTableViewCell) as? EmptyDataTableViewCell {
                cell.labelTitle.text = Localization.string(key: MessageKey.NoDashboard)
                cell.labelTitle.textColor = Colors.textDark
                
                return cell
            }
        } else {
            if indexPath.row == self.activities.count {
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
                        if let rating = activity.rating, let index = Int(rating) {
                            cell.stackView.setSelectedStar(index: index)
                        }
                        
                        cell.buttonViewImages.isHidden = true
                        cell.labelDescription.text = activity.description
                        cell.typeView.backgroundColor = Colors.appOrange
                        cell.labelTitle.textColor = Colors.appOrange
                        cell.typeImageView.image = #imageLiteral(resourceName: "food_icon")
                        
                        cell.stackViewHeightConstraint.constant = 20
                        cell.stackViewTopConstraint.constant = 8
                        cell.topViewHeightConstraint.constant = 120
                        cell.labelTitleTopConstraint.constant = 30
                        cell.labelTitleTopConstraint.constant = activity.description.isNullOrEmpty() ? 30 : 16
                    case ActivityType.Nap.rawValue:
                        cell.buttonViewImages.isHidden = true
                        cell.typeView.backgroundColor = Colors.appBlue
                        cell.labelTitle.textColor = Colors.appBlue
                        cell.typeImageView.image = #imageLiteral(resourceName: "nap_icon")
                        
                        if let fromTime = activity.from_date, let toTime = activity.to_date {
                            cell.labelDescription.text = "From \(fromTime) till \(toTime)"
                        }
                        
                        cell.stackViewHeightConstraint.constant = 0
                        cell.stackViewTopConstraint.constant = 8
                        cell.topViewHeightConstraint.constant = 120
                        cell.labelTitleTopConstraint.constant = 30
                        cell.labelTitleTopConstraint.constant = activity.description.isNullOrEmpty() ? 30 : 50
                    case ActivityType.Bathroom.rawValue:
                        cell.buttonViewImages.isHidden = true
                        cell.typeView.backgroundColor = Colors.appGreen
                        cell.labelTitle.textColor = Colors.appGreen
                        cell.typeImageView.image = #imageLiteral(resourceName: "bath_icon")
                        
                        cell.stackViewHeightConstraint.constant = 0
                        cell.stackViewTopConstraint.constant = 0
                        cell.topViewHeightConstraint.constant = 120
                        cell.labelTitleTopConstraint.constant = 20
                        
                        if let type = activity.getBathType(),
                            let pottyType = activity.getBathPottyType(),
                            let time = activity.time {
                            cell.labelDescription.text = "\(type)\n\(pottyType)\n\(time)"
                        }
                    case ActivityType.PottyTraining.rawValue:
                        cell.buttonViewImages.isHidden = true
                        cell.typeView.backgroundColor = Colors.appRed
                        cell.labelTitle.textColor = Colors.appRed
                        cell.typeImageView.image = #imageLiteral(resourceName: "potty_training_icon")
                        
                        if let time = activity.time {
                            cell.labelDescription.text = "At \(time)"
                        }
                        
                        cell.stackViewHeightConstraint.constant = 0
                        cell.stackViewTopConstraint.constant = 8
                        cell.topViewHeightConstraint.constant = 120
                        cell.labelTitleTopConstraint.constant = 30
                        cell.labelTitleTopConstraint.constant = activity.description.isNullOrEmpty() ? 30 : 50
                    case ActivityType.Additional.rawValue:
                        cell.buttonViewImages.isHidden = false
                        cell.typeView.backgroundColor = Colors.appPurple
                        cell.labelTitle.textColor = Colors.appPurple
                        cell.typeImageView.image = #imageLiteral(resourceName: "outing_icon")
                        
                        cell.labelTitleTopConstraint.constant = 40
                        cell.stackViewHeightConstraint.constant = 0
                        cell.topViewHeightConstraint.constant = 100
                        cell.stackViewTopConstraint.constant = 8
                        
                        cell.labelDescription.text = nil
                        
                        cell.buttonViewImages.addTarget(self, action: #selector(viewImagesTapped(sender:)), for: .touchUpInside)
                        cell.buttonViewImages.tag = indexPath.row
                    default:
                        break
                    }
                }
                
                cell.labelTitle.text = activity.title
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func viewImagesTapped(sender: UIButton) {
        if let galleryVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.GalleryViewController) as? GalleryViewController {
            if let photos = self.activities[sender.tag].photos {
                galleryVC.photos = photos
            }
            self.present(galleryVC, animated: true, completion: nil)
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
