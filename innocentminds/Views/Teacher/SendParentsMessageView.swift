//
//  SendParentsMessageView.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/14/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SendParentsMessageView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSend: UIButton!
    
//    fileprivate var messages: [ParentsMessage] = [
//        ParentsMessage.init(desc: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout", isSelected: false),
//        ParentsMessage.init(desc: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout", isSelected: false),
//        ParentsMessage.init(desc: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout", isSelected: false),
//        ParentsMessage.init(desc: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout", isSelected: false),
//        ParentsMessage.init(desc: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout", isSelected: false)
//    ]
    
    var messages: [Messages] = [Messages]()
    var selectedChild: Child = Child()
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.hide(remove: true)
    }
    
    func initializeViews() {
        if let messages = Objects.variables.messages {
            self.messages = messages
        }
        
        self.buttonSend.isHidden = self.messages.count == 0
        self.buttonSend.layer.cornerRadius = self.buttonSend.frame.height/2
        self.buttonSend.isEnabled(enable: false)
        
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.EmptyDataTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyDataTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.SendParentsMessageTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.SendParentsMessageTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count == 0 ? 1 : self.messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.messages.count == 0 ? tableView.frame.height : UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.messages.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyDataTableViewCell) as? EmptyDataTableViewCell {
                cell.labelTitle.text = Localization.string(key: MessageKey.NoMessage)
                
                return cell
            }
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SendParentsMessageTableViewCell) as? SendParentsMessageTableViewCell {
            cell.initializeViews()
            
            let message = self.messages[indexPath.row]
            cell.labelDescription.text = message.description
            
            let isSelected = message.isSelected == true ? true : false
            cell.updateSelectedMessage(isSelected: isSelected)
            
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:)))
            cell.addGestureRecognizer(cellTap)
            cell.tag = indexPath.row
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let cell = sender.view {
            let message = self.messages[cell.tag]
            let isSelected = message.isSelected == true ? true : false
            self.messages[cell.tag].isSelected = !isSelected
            
            self.tableView.reloadData()
            self.updateButtonSendStatus()
        }
    }
    
    func updateButtonSendStatus() {
        let selectedMessages = self.messages.filter { $0.isSelected == true }
        self.buttonSend.isEnabled(enable: selectedMessages.count > 0)
    }
    
    @IBAction func buttonSendTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.showLoader()
            
            var messageIds: String = ""
            for message in self.messages {
                if let id = message.id, message.isSelected == true {
                    messageIds.append("\(id),")
                }
            }
            messageIds.removeLast()
            
            let childId = self.selectedChild.id ?? "0"
            let parentId = self.selectedChild.parent_id ?? "0"
            
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.sendMessage(userId: parentId, childId: childId, messageIds: messageIds)
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue {
                        if let message = result?.message {
                            baseVC.showAlertView(message: message)
                        }
                    } else if let message = result?.message {
                        baseVC.showAlertView(message: message, isError: true)
                    } else {
                        baseVC.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                    }
                    
                    baseVC.hideLoader()
                    
                    self.messages.forEach { $0.isSelected = false }
                    self.tableView.reloadData()
                    
                    self.updateButtonSendStatus()
                }
            }
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

private class ParentsMessage {
    var desc: String!
    var isSelected: Bool!
    
    init(desc: String, isSelected: Bool) {
        self.desc = desc
        self.isSelected = isSelected
    }
}
