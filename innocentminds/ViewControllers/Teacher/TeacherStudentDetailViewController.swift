//
//  TeacherStudentDetailViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/6/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class TeacherStudentDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageViewChild: UIImageView!
    @IBOutlet weak var labelChildName: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonDailyAgenda: UIButton!
    @IBOutlet weak var buttonAdditionalActivities: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var segmentView: UIView!
    
    var dailyAgendas: [Activity] = [Activity]()
    var selectedChildId: String = ""
    
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
        
        self.imageViewChild.layer.cornerRadius = self.imageViewChild.frame.height/2
        self.imageViewChild.layer.borderColor = Colors.darkBlue.cgColor
        self.imageViewChild.layer.borderWidth = 2
        
        self.segmentView.customizeView()
        
        self.buttonDailyAgenda.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonAdditionalActivities.layer.cornerRadius = Dimensions.cornerRadiusNormal
        
//        self.setButtonActivitySelected(tag: 1)
        
        let sendMessageTap = UITapGestureRecognizer(target: self, action: #selector(sendMessageTapped))
        self.viewSendMessage.addGestureRecognizer(sendMessageTap)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.EmptyActivityTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyActivityTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.AddActivityHeaderTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.AddActivityHeaderTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.AddActivityPostTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.AddActivityPostTableViewCell)
        
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailyAgendas.count == 0 ? 1 : self.dailyAgendas.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dailyAgendas.count == 0 ? 150 : indexPath.row == 0 ? 70 : 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.dailyAgendas.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyActivityTableViewCell) as? EmptyActivityTableViewCell {
                cell.initializeViews()
                
                cell.labelTitle.text = "No daily agendas yet"
                cell.labelDescription.text = "You haven't logged any daily agendas\nfor this student today"
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.AddActivityHeaderTableViewCell) as? AddActivityHeaderTableViewCell {
                    cell.initializeViews()
                    
                    let cellTap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
                    cell.addGestureRecognizer(cellTap)
                    
                    return cell
                }
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.AddActivityPostTableViewCell) as? AddActivityPostTableViewCell {
                cell.initializeViews()
                
                cell.labelTitleTopConstraint.constant = 10
                cell.stackViewHeightContraint.constant = 20
                cell.labelDescriptionTopConstraint.constant = 8
                
                let activity = self.dailyAgendas[indexPath.row-1]
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
                    case ActivityType.Bathroom.rawValue:
                        cell.typeView.backgroundColor = Colors.appGreen
                        cell.labelTitle.textColor = Colors.appGreen
                        cell.typeImageView.image = #imageLiteral(resourceName: "bath_icon")
                    case ActivityType.PottyTraining.rawValue:
                        cell.typeView.backgroundColor = Colors.appRed
                        cell.labelTitle.textColor = Colors.appRed
                        cell.typeImageView.image = #imageLiteral(resourceName: "potty_training_icon")
                    default:
                        break
                    }
                }
                
                cell.labelTitle.text = activity.title
                cell.labelDescription.text = activity.description
                cell.buttonViewImages.isHidden = true
                
                if let rating = activity.rating, let index = Int(rating) {
                    let starIndex = index == -1 ? 0 : index
                    cell.stackView.setSelectedStar(index: starIndex)
                }
                
                for view in cell.stackView.subviews {
                    view.isUserInteractionEnabled = false
                }
                
                cell.buttonEdit.addTarget(self, action: #selector(buttonEditTapped(sender:)), for: .touchUpInside)
                cell.buttonEdit.tag = indexPath.row-1
                
                cell.buttonDelete.addTarget(self, action: #selector(buttonDeleteTapped(sender:)), for: .touchUpInside)
                cell.buttonDelete.tag = indexPath.row-1
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func cellTapped() {
        self.redirectToVC(storyboard: teacherStoryboard, storyboardId: StoryboardIds.AddDailyAgendaViewController, type: .present)
    }
    
    @objc func sendMessageTapped() {
        if let sendParentsMessageView = self.showView(name: Views.SendParentsMessageView) as? SendParentsMessageView {
            sendParentsMessageView.initializeViews()
            sendParentsMessageView.selectedChildId = self.selectedChildId
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    var editActivityIndex = 0
    @objc func buttonEditTapped(sender: UIButton) {
        self.editActivityIndex = sender.tag
        if let addDailyAgendaVC = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.AddDailyAgendaViewController) as? AddDailyAgendaViewController {
            addDailyAgendaVC.mode = .edit
            addDailyAgendaVC.activity = self.dailyAgendas[sender.tag]
            addDailyAgendaVC.selectedActivityIndex = sender.tag
            self.present(addDailyAgendaVC, animated: true, completion: nil)
        }
    }
    
    var deleteActivityIndex = 0
    @objc func buttonDeleteTapped(sender: UIButton) {
        self.deleteActivityIndex = sender.tag
        self.showAlertView(message: Localization.string(key: MessageKey.DeleteActivity), buttonOkTitle: Localization.string(key: MessageKey.Delete), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.deleteActivity), for: .touchUpInside)
        }
    }
    
    @objc func deleteActivity() {
        if let activityToDeleteId = self.dailyAgendas[self.deleteActivityIndex].id {
            self.showLoader()
            
            DispatchQueue.global(qos: .background).async {
                _ = appDelegate.services.deleteActivity(id: activityToDeleteId)
                
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.hideView()
                }
            }
        } else {
            self.hideView()
        }
        
        self.dailyAgendas.remove(at: self.deleteActivityIndex)
        self.tableView.reloadData()
    }
    
//    @IBAction func buttonActivityTapped(_ sender: Any) {
//        if let button = sender as? UIButton {
//            self.setButtonActivitySelected(tag: button.tag)
//        }
//    }
//
//    func setButtonActivitySelected(tag: Int) {
//        switch tag {
//        case 1:
//            self.buttonDailyAgenda.isSelected = true
//            self.buttonDailyAgenda.backgroundColor = Colors.white
//            self.buttonDailyAgenda.setTitleColor(Colors.textDark, for: .selected)
//
//            self.buttonAdditionalActivities.isSelected = false
//            self.buttonAdditionalActivities.backgroundColor = .clear
//            self.buttonAdditionalActivities.setTitleColor(Colors.white, for: .normal)
//        case 2:
//            self.buttonAdditionalActivities.isSelected = true
//            self.buttonAdditionalActivities.backgroundColor = Colors.white
//            self.buttonAdditionalActivities.setTitleColor(Colors.textDark, for: .selected)
//
//            self.buttonDailyAgenda.isSelected = false
//            self.buttonDailyAgenda.backgroundColor = .clear
//            self.buttonDailyAgenda.setTitleColor(Colors.white, for: .normal)
//        default:
//            break
//        }
//
//        self.tableView.reloadData()
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
