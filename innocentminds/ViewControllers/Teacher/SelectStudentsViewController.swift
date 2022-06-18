//
//  SelectStudentsViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/2/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import Kingfisher

class SelectStudentsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    var students: [Child] = [Child]()
    var selectedIds: [Int] = [Int]()
    var selectedActivityIndex = 0
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initializeViews() {
        self.buttonConfirm.layer.cornerRadius = self.buttonConfirm.frame.height/2
        self.buttonConfirm.isEnabled(enable: self.selectedIds.count>0)
        
        if let students = Objects.user.children {
            self.students = students
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.SelectStudentsTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.SelectStudentsTableViewCell)
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SelectStudentsTableViewCell) as? SelectStudentsTableViewCell {
            cell.initializeViews()
            
            let student = self.students[indexPath.row]
            
            if let image = student.image, !image.isEmpty {
                cell.imageViewProfile.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
            } else {
                cell.imageViewProfile.image = #imageLiteral(resourceName: "boy_avatar")//.withRenderingMode(.alwaysTemplate)
//                cell.imageViewProfile.tintColor = Colors.lightGray
            }
            
            if let firstName = student.firstname, let lastName = student.lastname {
                cell.labelName.text = firstName + " " + lastName
            }
            
            if let id = student.id, let studentId = Int(id) {
                let isSelected = self.selectedIds.contains(studentId)
                cell.buttonCheck.isSelected = isSelected
                cell.labelName.textColor = isSelected ? Colors.appBlue : Colors.textDark
            }
            
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
            cell.addGestureRecognizer(cellTap)
            cell.tag = indexPath.row
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        if let addAdditionalActivityVC = self.presentingViewController as? AddAdditionalActivityViewController {
            addAdditionalActivityVC.selectedStudentIds = self.selectedIds
        } else if let navigationController = self.presentingViewController as? UINavigationController, let additionalActivityVC = navigationController.children.last as? AdditionalActivityViewController {
            let activity = additionalActivityVC.additionalActivities[self.selectedActivityIndex]
            activity.student_ids = ""
            for id in self.selectedIds {
                activity.student_ids?.append("\(id),")
            }
            
            activity.student_ids?.removeLast()
        }
        
        self.dismissVC()
    }
    
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        if let cell = sender.view as? SelectStudentsTableViewCell {
            cell.buttonCheck.isSelected = !cell.buttonCheck.isSelected
            cell.labelName.textColor = cell.buttonCheck.isSelected ? Colors.appBlue : Colors.textDark
            
            if let id = self.students[cell.tag].id, let studentId = Int(id) {
                if cell.buttonCheck.isSelected {
                    self.selectedIds.append(studentId)
                } else if let indexToRemove = self.selectedIds.index(of: studentId) {
                    self.selectedIds.remove(at: indexToRemove)
                }
            }
        }
        
        self.buttonConfirm.isEnabled(enable: self.selectedIds.count>0)
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
