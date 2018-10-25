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
        
        if let students = currentUser.children {
            self.students = students
        }
        if let selectedClass = currentUser.classes?.first {
            self.selectedClass = selectedClass
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.TeacherStudentTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.TeacherStudentTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.TeacherStudentHeaderTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.TeacherStudentHeaderTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//self.students.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TeacherStudentHeaderTableViewCell) as? TeacherStudentHeaderTableViewCell {            
            cell.labelClass.text = self.selectedClass.name
            
            cell.buttonAdditionActivities.addTarget(self, action: #selector(buttonAdditionActivitiesTapped), for: .touchUpInside)
            
            return cell
        }
        
        return nil
    }
    
    @objc func buttonAdditionActivitiesTapped() {
        self.redirectToVC(storyboard: teacherStoryboard, storyboardId: StoryboardIds.AdditionalActivityViewController, type: .push)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TeacherStudentTableViewCell) as? TeacherStudentTableViewCell {            
            cell.initializeViews()
            
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:)))
            cell.addGestureRecognizer(cellTap)
            cell.tag = indexPath.row

            cell.imageViewProfile.image = #imageLiteral(resourceName: "avatar_baby")
            cell.labelStudentName.text = "Maya Nehme \(indexPath.row)"
            
//            let student = self.students[indexPath.row]
//
//            if let image = student.image {
//                cell.imageViewProfile.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
//            }
//            if let firstName = student.firstname, let lastName = student.lastname {
//                cell.labelStudentName.text = firstName + " " + lastName
//            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let cell = sender.view {
            if let teacherStudentDetailVC = teacherStoryboard.instantiateViewController(withIdentifier: StoryboardIds.TeacherStudentDetailViewController) as? TeacherStudentDetailViewController {
//                if let childId = self.students[cell.tag].id {
//                    teacherStudentDetailVC.selectedChildId = childId
//                }
//                if let childActivities = self.students[cell.tag].activities {
//                    teacherStudentDetailVC.dailyAgendas = childActivities
//                }
                self.navigationController?.pushViewController(teacherStudentDetailVC, animated: true)
            }
        }
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.showAlertView(message: Localization.string(key: MessageKey.Logout), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        }
    }
    
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        
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
