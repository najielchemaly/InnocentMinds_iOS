//
//  MessagesView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class MessagesView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonNotifications: UIButton!
    @IBOutlet weak var buttonMessages: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNotificationBadge: UILabel!
    @IBOutlet weak var labelMessageBadge: UILabel!
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var messagesView: UIView!
    @IBOutlet weak var horizontalSeperatorView: UIView!
    
    var messageType: Int = MessageType.Notifications.rawValue
    var notifications: [Notification] = [Notification]()    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
    @IBAction func buttonNotificationsTapped(_ sender: Any) {
        self.messageType = MessageType.Notifications.rawValue
        self.buttonNotifications.isSelected = true
        if let fontName = Fonts.montserrat_names[1] {
            self.buttonNotifications.titleLabel?.font = UIFont.init(name: fontName, size: 13)!
        }
//        self.buttonMessages.isSelected = false
//        if let fontName = Fonts.montserrat_names[0] {
//            self.buttonMessages.titleLabel?.font = UIFont.init(name: fontName, size: 13)!
//        }
        self.tableView.reloadData()
        
        DispatchQueue.global(qos: .background).async {
            // Fetch notifications from server
            DispatchQueue.main.async {
                // Reload data
            }
        }
    }
    
    @IBAction func buttonMessagesTapped(_ sender: Any) {
        self.messageType = MessageType.Messages.rawValue
        self.buttonNotifications.isSelected = false
        if let fontName = Fonts.montserrat_names[0] {
            self.buttonNotifications.titleLabel?.font = UIFont.init(name: fontName, size: 14)!
        }
        self.buttonMessages.isSelected = true
        if let fontName = Fonts.montserrat_names[1] {
            self.buttonMessages.titleLabel?.font = UIFont.init(name: fontName, size: 14)!
        }
        self.tableView.reloadData()
        
        DispatchQueue.global(qos: .background).async {
            // Fetch messages from server
            DispatchQueue.main.async {
                // Reload data
            }
        }
    }
    
    func initializeViews() {
        self.mainView.layer.cornerRadius = Dimensions.cornerRadiusMedium
        self.labelNotificationBadge.layer.cornerRadius = self.labelNotificationBadge.frame.height/2
        self.labelMessageBadge.layer.cornerRadius = self.labelMessageBadge.frame.height/2
        
        // Removed for the first release
        self.messagesView.removeFromSuperview()
        self.horizontalSeperatorView.removeFromSuperview()
        self.buttonNotifications.isUserInteractionEnabled = false
        
        self.getNotifications()
        
//        let swipeRightTap = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
//        swipeRightTap.direction = .right
//        self.mainView.addGestureRecognizer(swipeRightTap)
//
//        let swipeLeftTap = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
//        swipeLeftTap.direction = .left
//        self.mainView.addGestureRecognizer(swipeLeftTap)
        
//        self.notifications = [
//            Notification(id: "1", description: "This is a test description for notifications, This is a test description for notifications 1", is_read: false, date: "2018-10-10 18:21:00"),
//            Notification(id: "2", description: "This is a test description for notifications, This is a test description for notifications 2", is_read: false, date: "2018-10-10 20:35:15"),
//            Notification(id: "3", description: "This is a test description for notifications, This is a test description for notifications 3", is_read: false, date: "2018-10-10 21:25:00"),
//            Notification(id: "4", description: "This is a test description for notifications, This is a test description for notifications 4", is_read: true, date: "2018-10-10 23:06:26"),
//            Notification(id: "5", description: "This is a test description for notifications, This is a test description for notifications 5", is_read: true, date: "2018-10-11 02:45:00")
//        ]
    }
    
    @objc func swipeRight() {
        self.buttonNotificationsTapped(self.buttonNotifications)
    }
    
    @objc func swipeLeft() {
        self.buttonMessagesTapped(self.buttonMessages)
    }
    
    func getNotifications(shouldReload: Bool = true) {
        if let baseVC = currentVC as? BaseViewController {
            if shouldReload {
                baseVC.showLoader()
            }
            
            let userId = Objects.user.id ?? "0"
            
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.getNotifications(id: userId)
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue {
                        if let jsonObject = result?.json?.first, let jsonArray = jsonObject["notifications"] as? [NSDictionary] {
                            self.notifications = [Notification]()
                            for json in jsonArray {
                                guard let notification = Notification.init(dictionary: json) else {
                                    return
                                }
                                
                                self.notifications.append(notification)
                            }
                        }
                        
                        self.tableView.reloadData()
                    }
                    
                    self.refreshControl.endRefreshing()
                    
                    baseVC.hideLoader()
                }
            }
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.EmptyDataTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyDataTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.NotificationTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.NotificationTableViewCell)
//        self.tableView.register(UINib.init(nibName: CellIds.AddNewMessageTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.AddNewMessageTableViewCell)
//        self.tableView.register(UINib.init(nibName: CellIds.MessageTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.MessageTableViewCell)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func handleRefresh() {
        self.getNotifications(shouldReload: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.messageType {
        case MessageType.Notifications.rawValue:
            return self.notifications.count == 0 ? 1 : self.notifications.count
        case MessageType.Messages.rawValue:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.messageType {
        case MessageType.Notifications.rawValue:
            return self.notifications.count == 0 ? tableView.frame.height : 100
        case MessageType.Messages.rawValue:
            if indexPath.row == 0 {
                return 60
            }
            
            return 100
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.messageType {
        case MessageType.Notifications.rawValue:
            if self.notifications.count == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyDataTableViewCell) as? EmptyDataTableViewCell {
                    cell.labelTitle.text = Localization.string(key: MessageKey.NoNotifications)
                    cell.labelTitle.textColor = Colors.textDark
                    
                    cell.buttonCompleteProfile.isHidden = true
                    
                    return cell
                }
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.NotificationTableViewCell) as? NotificationTableViewCell {
                cell.selectionStyle = .none
                
                let notification = self.notifications[indexPath.row]
                cell.labelDescription.text = notification.description
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let dateString = notification.date, let date = dateFormatter.date(from: dateString) {
                    cell.labelTime.text = timeAgoSince(date)
                }

                cell.notificationImageView.image = notification.is_read == true ? #imageLiteral(resourceName: "inbox_message_gray") : #imageLiteral(resourceName: "inbox_message_red")
                cell.labelDescription.textColor = notification.is_read == true ? Colors.textDark : Colors.appOrange
                
                if notification.is_read != true {
                    let userId = Objects.user.id ?? "0"
                    DispatchQueue.global(qos: .background).async {
                        if let id = notification.id {
                            let result = appDelegate.services.updateNotification(id: userId, notifId: id, isRead: true)
                            if result?.status == ResponseStatus.SUCCESS.rawValue {
                                self.notifications[indexPath.row].is_read = true
                            }
                        }
                    }
                }
                
                return cell
            }
        case MessageType.Messages.rawValue:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.AddNewMessageTableViewCell) as? AddNewMessageTableViewCell {
                    cell.selectionStyle = .none
                    
                    return cell
                }
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.MessageTableViewCell) as? MessageTableViewCell {
                cell.selectionStyle = .none
                cell.initializeViews()
                
                cell.labelDescription.text = "Hello John, we are please to inform you that your daugther is making better progress since our last discussion."
                
                if indexPath.row > 2 {
                    cell.inboxImageView.image = #imageLiteral(resourceName: "inbox_message_gray")
                    cell.labelDescription.textColor = Colors.textDark
                }
                
                let cellTap = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:)))
                cell.addGestureRecognizer(cellTap)
                cell.tag = indexPath.row
                
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            if let id = self.notifications[indexPath.row].id {
                let userId = Objects.user.id ?? "0"
                DispatchQueue.global(qos: .background).async {
                    _ = appDelegate.services.updateNotification(id: userId, notifId: id, isDeleted: true)
                }
                
                self.notifications.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let cell = sender.view, let baseVC = currentVC as? BaseViewController {
            baseVC.redirectToVC(storyboardId: StoryboardIds.MessageDetailsViewController, type: .push)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
