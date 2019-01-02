//
//  SearchViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/2/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var students: [Child] = [Child]()
    var filteredStudents: [Child] = [Child]()
    var classes: [Class] = [Class]()
    
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
        self.searchView.layer.cornerRadius = self.searchView.frame.height/2
        
        if let students = Objects.user.children {
            self.students = students
            self.filteredStudents = students
        }
        
        if let classes = Objects.user.classes {
            self.classes = classes
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.EmptyDataTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyDataTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.SearchTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.SearchTableViewCell)
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredStudents.count == 0 ? 1 : self.filteredStudents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.filteredStudents.count == 0 ? tableView.frame.height : 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.filteredStudents.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyDataTableViewCell) as? EmptyDataTableViewCell {
                cell.labelTitle.text = Localization.string(key: MessageKey.NoResultFound)
                cell.labelTitle.textColor = Colors.textDark
                
                return cell
            }
        }else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SearchTableViewCell) as? SearchTableViewCell {
            cell.initializeViews()
            
            let student = self.filteredStudents[indexPath.row]
            
            if let image = student.image, !image.isEmpty {
                cell.imageViewProfile.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
            } else {
                cell.imageViewProfile.image = #imageLiteral(resourceName: "boy_avatar").withRenderingMode(.alwaysTemplate)
                cell.imageViewProfile.tintColor = Colors.lightGray
            }
            
            if let firstName = student.firstname, let lastName = student.lastname {
                cell.labelName.text = "\(firstName) \(lastName)"
            }
            
            if let classId = student.class_id {
                let filteredClasses = self.classes.filter { $0.id == classId }
                if let className = filteredClasses.first?.name {
                    cell.labelClass.text = className
                }
            }
            
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
            cell.addGestureRecognizer(cellTap)
            cell.tag = indexPath.row
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        if let cell = sender.view {
            if let nurseStudentDetailVC = nurseStoryboard.instantiateViewController(withIdentifier: StoryboardIds.NurseStudentDetailViewController) as? NurseStudentDetailViewController,
                let navigationController = self.navigationController {
                nurseStudentDetailVC.selectedStudent = self.filteredStudents[cell.tag]
                navigationController.pushViewController(nurseStudentDetailVC, animated: true)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, !text.isEmpty {
            var searchText = text
            if string.isEmpty {
                searchText.removeLast()
            } else {
                searchText = "\(searchText)\(string)".lowercased()
            }
            
            if !searchText.isEmpty {
                self.filteredStudents = self.filteredStudents.filter { ($0.firstname?.lowercased().contains(searchText))! || ($0.lastname?.lowercased().contains(searchText))! }
            } else {
                self.filteredStudents = self.students
            }
        }
        
        self.tableView.reloadData()
        
        return true
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.searchTextField.text = nil
        self.filteredStudents = self.students
        
        self.tableView.reloadData()
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
