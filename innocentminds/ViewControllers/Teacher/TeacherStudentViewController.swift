//
//  TeacherStudentViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/4/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import Kingfisher

class TeacherStudentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelTeacherName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var students: [Child] = [Child]()
    var selectedClass: Class = Class()
    
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
        self.buttonSubmit.layer.cornerRadius = self.buttonSubmit.frame.height/2
        
        if let fullname = Objects.user.fullname {
            self.labelTeacherName.text = "\(fullname) (teacher)"
        }
        
        if let students = Objects.user.children {
            self.students = students
        }
        
        if let selectedClass = Objects.user.classes?.first {
            self.selectedClass = selectedClass
        }
        
        if let roleId = Objects.user.role_id, roleId == UserRole.Teacher.rawValue {
            self.buttonSubmit.isHidden = true
        } else {
            self.buttonSubmit.isHidden = self.students.count == 0
        }
        
        self.tableView.isScrollEnabled = self.students.count > 0
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.TeacherStudentTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.TeacherStudentTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.TeacherStudentHeaderTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.TeacherStudentHeaderTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.EmptyDataTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyDataTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count == 0 ? 1 : self.students.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.students.count == 0 ? tableView.frame.height : 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.students.count > 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TeacherStudentHeaderTableViewCell) as? TeacherStudentHeaderTableViewCell {
                cell.labelClass.text = self.selectedClass.name
                
                cell.buttonAdditionActivities.addTarget(self, action: #selector(buttonAdditionActivitiesTapped), for: .touchUpInside)
                
                return cell
            }
        }
        
        return nil
    }
    
    @objc func buttonAdditionActivitiesTapped() {
        self.redirectToVC(storyboard: teacherStoryboard, storyboardId: StoryboardIds.AdditionalActivityViewController, type: .push)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.students.count == 0 ? 0 : 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.students.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyDataTableViewCell) as? EmptyDataTableViewCell {
                cell.labelTitle.text = Localization.string(key: MessageKey.NoStudents)
                cell.labelTitle.textColor = Colors.textDark
                
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TeacherStudentTableViewCell) as? TeacherStudentTableViewCell {
                cell.initializeViews()
                
                let cellTap = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:)))
                cell.addGestureRecognizer(cellTap)
                cell.tag = indexPath.row
                
                let student = self.students[indexPath.row]

                if let image = student.image, !image.isEmpty {
                    cell.imageViewProfile.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
                } else {
                    cell.imageViewProfile.image = #imageLiteral(resourceName: "boy_avatar").withRenderingMode(.alwaysTemplate)
                    cell.imageViewProfile.tintColor = Colors.lightGray
                }
                if let firstName = student.firstname, let lastName = student.lastname {
                    cell.labelStudentName.text = firstName + " " + lastName
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let cell = sender.view {
            if let teacherStudentDetailVC = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.TeacherStudentDetailViewController) as? TeacherStudentDetailViewController {
                teacherStudentDetailVC.selectedStudent = self.students[cell.tag]
                self.navigationController?.pushViewController(teacherStudentDetailVC, animated: true)
            }
        }
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.showAlertView(message: Localization.string(key: MessageKey.LogoutValidation), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        }
    }
    
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        self.showAlertView(message: Localization.string(key: MessageKey.PublishActivities), buttonOkTitle: Localization.string(key: MessageKey.Publish), buttonCancelTitle: Localization.string(key: MessageKey.Cancel))
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.submitActivities), for: .touchUpInside)
        }
    }
    
    @objc func submitActivities() {
        self.showLoader()
        
        let publishActivityId = PublishActivityId(activities_ids: self.getActivitiesIds())
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.publishActivity(publishActivityId: publishActivityId)
            
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue {
                    if let message = result?.message {
                        self.showAlertView(message: message)
                    } else {
                        self.showAlertView(message: Localization.string(key: MessageKey.ActivitiesPublished))
                    }
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
    
    func getActivitiesIds() -> [Int] {
        var activitiesIds: [Int] = [Int]()
        for student in self.students {
            guard let dailyAgendas = student.activities else {
                return [Int]()
            }
            
            for activity in dailyAgendas {
                if let activityId = activity.id {
                    guard let id = Int(activityId) else {
                        return [Int]()
                    }
                    
                    activitiesIds.append(id)
                }
            }
        }
        
        guard let additionalActivities = Objects.user.additional_activities else {
            return [Int]()
        }
        
        for activity in additionalActivities {
            if let activityId = activity.id {
                guard let id = Int(activityId) else {
                    return [Int]()
                }
                
                activitiesIds.append(id)
            }
        }
        
        return activitiesIds
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
