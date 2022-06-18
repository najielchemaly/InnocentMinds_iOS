//
//  ContactUsViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/29/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonLogout: UIButton!
    
    var contactUsList: [Contact] = [Contact]()
    var filteredContactUsList: [Contact] = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initiliazeViews()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonBranchTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            setButtonSeleted(button: button)
            switch button.tag {
            case 1:
                self.filteredContactUsList = self.contactUsList.filter { $0.branch_id == BranchId.Bliss.rawValue }
            case 2:
                self.filteredContactUsList = self.contactUsList.filter { $0.branch_id == BranchId.Hazmieh.rawValue }
            case 3:
                self.filteredContactUsList = self.contactUsList.filter { $0.branch_id == BranchId.Sanayeh.rawValue }
            default:
                break
            }
            
            self.tableView.reloadData()
        }
    }
    
    func setButtonSeleted(button: UIButton) {
        for subview in stackView.subviews {
            if let button = subview as? UIButton {
                button.isSelected = false
            }
        }
        
        button.isSelected = true
    }
    
    func initiliazeViews() {
        if self.tabBarController is GuestTabBarViewController {
            self.buttonClose.isHidden = true
            self.buttonLogout.isHidden = false
        } else {
            self.buttonClose.isHidden = false
            self.buttonLogout.isHidden = true
        }
    }
    
    func setupTableView() {
        if let contacts = Objects.variables.contacts {
            self.contactUsList = contacts
        }
        
        self.filteredContactUsList = self.contactUsList.filter { $0.branch_id == BranchId.Bliss.rawValue }
        
        self.tableView.register(UINib.init(nibName: CellIds.PhoneNumberTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.PhoneNumberTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.LocateUsTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.LocateUsTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.SendUsMessageTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.SendUsMessageTableViewCell)
        
        self.tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let count = filteredContactUsList.first?.phone_numbers?.count {
                return count
            }
            return 0
        case 1, 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            return 90
        case 2:
            return 90
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.PhoneNumberTableViewCell) as? PhoneNumberTableViewCell {
                cell.selectionStyle = .none
                cell.initializeViews()
                
                cell.buttonCall.tag = indexPath.row
                cell.buttonCall.addTarget(self, action: #selector(buttonCallTapped(sender:)), for: .touchUpInside)
                
                guard let contactUs = self.filteredContactUsList.first else {
                    return cell
                }
                
                if let phoneList = contactUs.phone_numbers {
                    cell.labelPhone.text = phoneList[indexPath.row].text
                }
                
                if let branchId = contactUs.branch_id {
                    switch branchId {
                    case "1":
                        cell.mainView.backgroundColor = Colors.appGreen
                        break
                    case "2":
                        cell.mainView.backgroundColor = Colors.appRed
                        break
                    case "3":
                        cell.mainView.backgroundColor = Colors.appBlue
                        break
                    default:
                        break
                    }
                }
                
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.LocateUsTableViewCell) as? LocateUsTableViewCell {
                cell.selectionStyle = .none
                cell.initializeViews()
                
                let cellTap = UITapGestureRecognizer(target: self, action: #selector(locateUsTapped))
                cell.addGestureRecognizer(cellTap)
                
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SendUsMessageTableViewCell) as? SendUsMessageTableViewCell {
                cell.selectionStyle = .none
                cell.initializeViews()
                
                let cellTap = UITapGestureRecognizer(target: self, action: #selector(sendUsMessageTapped))
                cell.addGestureRecognizer(cellTap)
                
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    @objc func buttonCallTapped(sender: UIButton) {
        if let phoneList = self.filteredContactUsList.first?.phone_numbers, let number = phoneList[sender.tag].text {
            guard let numberUrl = URL(string: "tel://" + number.replacingOccurrences(of: " ", with: "")) else {
                return
            }
            
            UIApplication.shared.open(numberUrl)
        }
    }
    
    @objc func locateUsTapped() {
        if let location = self.filteredContactUsList.first?.location {
            let coordinates = location.split{$0 == ","}.map(String.init)
            if let latitude = coordinates.first?.trimmingCharacters(in: .whitespacesAndNewlines),
                let longitude = coordinates.last?.trimmingCharacters(in: .whitespacesAndNewlines) {
                guard let googleMapsUrl = URL(string: "comgooglemaps://") else {
                    return
                }
                
                if (UIApplication.shared.canOpenURL(googleMapsUrl)) {
                    guard let mapUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") else {
                        return
                    }
                    
                    UIApplication.shared.open(mapUrl)
                } else {
                    guard let mapUrl = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") else {
                        return
                    }
                    
                    UIApplication.shared.open(mapUrl)
                }
            }
        }
    }
    
    @objc func sendUsMessageTapped() {
        if let sendMessageView = self.showView(name: Views.SendUsMessageView) as? SendUsMessageView {
            sendMessageView.initializeViews()
        }
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.showAlertView(message: Localization.string(key: MessageKey.MainMenuValidation), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
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

class ContactUs {
    var branch: String!
    var phoneList: [String]!
    var location: String!
    
    init(branch: String, phoneList: [String], location: String) {
        self.branch = branch
        self.phoneList = phoneList
        self.location = location
    }
}
