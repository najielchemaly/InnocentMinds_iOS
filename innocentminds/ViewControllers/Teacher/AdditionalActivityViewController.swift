//
//  AdditionalActivityViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/11/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class AdditionalActivityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var additionalActivities: [Activity] = [Activity]()
    var shouldAskBeforeLeaving: Bool = false
    
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
        self.buttonSubmit.layer.cornerRadius = self.buttonSubmit.frame.height/2
        
        if let activities = Objects.user.additional_activities {
            self.additionalActivities = activities
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.EmptyActivityTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyActivityTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.AddActivityHeaderTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.AddActivityHeaderTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.AddActivityPostTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.AddActivityPostTableViewCell)
        
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additionalActivities.count == 0 ? 1 : additionalActivities.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return additionalActivities.count == 0 ? Localization.currentLanguage() == "en" ? 150 : 200 : indexPath.row == 0 ? 70 : 160
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if self.additionalActivities.count > 0, let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.AddActivityHeaderTableViewCell) as? AddActivityHeaderTableViewCell {
//            cell.initializeViews()
//
//            return cell
//        }
//
//        return nil
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return self.additionalActivities.count > 0 ? 60 : 0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.additionalActivities.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyActivityTableViewCell) as? EmptyActivityTableViewCell {
                cell.initializeViews()
                
                cell.labelTitle.text = Localization.string(key: MessageKey.NoAdditionalActivities)
                cell.labelDescription.text = Localization.string(key: MessageKey.NoAdditionalActivitiesMessage)
                
                return cell
            }
        } else {
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.AddActivityHeaderTableViewCell) as? AddActivityHeaderTableViewCell {
                    cell.initializeViews()
                    
                    cell.labelTitle.text = Localization.string(key: MessageKey.AddAdditionalActivity)
                    
                    let cellTap = UITapGestureRecognizer(target: self, action: #selector(addActivityCellTapped))
                    cell.addGestureRecognizer(cellTap)
                    
                    return cell
                }
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.AddActivityPostTableViewCell) as? AddActivityPostTableViewCell {
                cell.initializeViews()
                
                cell.labelTitleTopConstraint.constant = 20
                cell.stackViewHeightContraint.constant = 0
                cell.labelDescriptionTopConstraint.constant = 0
                
                cell.buttonViewStudents.isHidden = false
                cell.buttonViewImages.isHidden = false
                
                cell.typeView.backgroundColor = Colors.appPurple
                cell.labelTitle.textColor = Colors.appPurple
                cell.typeImageView.image = #imageLiteral(resourceName: "outing_icon")

                let row = indexPath.row-1
                
                let activity = self.additionalActivities[row]
                cell.labelTitle.text = activity.title
                cell.labelDescription.text = activity.description
                
                cell.buttonEdit.addTarget(self, action: #selector(buttonEditTapped(sender:)), for: .touchUpInside)
                cell.buttonEdit.tag = row
                
                cell.buttonDelete.addTarget(self, action: #selector(buttonDeleteTapped(sender:)), for: .touchUpInside)
                cell.buttonDelete.tag = row
                
                cell.buttonViewStudents.addTarget(self, action: #selector(buttonViewStudentsTapped(sender:)), for: .touchUpInside)
                cell.buttonViewStudents.tag = row
                
                cell.buttonViewImages.addTarget(self, action: #selector(buttonViewImagesTapped(sender:)), for: .touchUpInside)
                cell.buttonViewImages.tag = row
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        if self.shouldAskBeforeLeaving {
            self.showAlertView(message: Localization.string(key: MessageKey.LeaveWithoutSaving), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel))
            
            if let alertView = self.customView as? AlertView {
                alertView.buttonOk.addTarget(self, action: #selector(self.popVC), for: .touchUpInside)
            }
        } else {
            self.popVC()
        }
    }
    
    @objc func addActivityCellTapped() {
        self.redirectToVC(storyboard: teacherStoryboard, storyboardId: StoryboardIds.AddAdditionalActivityViewController, type: .present)
    }
    
    var editActivityIndex = 0
    @objc func buttonEditTapped(sender: UIButton) {
        self.editActivityIndex = sender.tag
        if let addAdditionalActivityVC = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.AddAdditionalActivityViewController) as? AddAdditionalActivityViewController {
            addAdditionalActivityVC.mode = .edit
            addAdditionalActivityVC.activity = self.additionalActivities[sender.tag]
            self.present(addAdditionalActivityVC, animated: true, completion: nil)
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
        if let activityToDeleteId = self.additionalActivities[self.deleteActivityIndex].id {
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
        
        self.additionalActivities.remove(at: self.deleteActivityIndex)
        self.tableView.reloadData()
    }
    
    @objc func buttonViewStudentsTapped(sender: UIButton) {
        if let selectStudentsVC = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.SelectStudentsViewController) as? SelectStudentsViewController {
            if let studentIds = self.additionalActivities[sender.tag].student_ids {
                selectStudentsVC.selectedIds = [Int]()
                selectStudentsVC.selectedActivityIndex = sender.tag
                let studentIdsArray = studentIds.split(separator: ",")
                for studentId in studentIdsArray {
                    if let id = Int(studentId) {
                        selectStudentsVC.selectedIds.append(id)
                    }
                }
            }
            
            self.present(selectStudentsVC, animated: true, completion: nil)
        }
    }
    
    @objc func buttonViewImagesTapped(sender: UIButton) {
        if let addPhotoViewController = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.AddPhotosViewController) as? AddPhotosViewController {
            if let photos = self.additionalActivities[sender.tag].photos {
                addPhotoViewController.photos = photos
                addPhotoViewController.selectedActivityIndex = sender.tag
            }
            self.present(addPhotoViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        self.showLoader()
        
        if let userId = Objects.user.id, let id = Int(userId) {
            let sendActivity = SendActivity(user_id: id, child_id: -1, child_activities: self.additionalActivities)
            
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.addActivity(sendActivity: sendActivity)
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue {
                        if let message = result?.message {
                            self.showAlertView(message: message)
                        } else {
                            self.showAlertView(message: Localization.string(key: MessageKey.ActivitiesSent))
                        }
                        
                        self.shouldAskBeforeLeaving = false
                    } else {
                        if let message = result?.message {
                            self.showAlertView(message: message, isError: true)
                        } else {
                            self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                        }
                    }
                    
                    self.hideLoader()
                }
            }
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
