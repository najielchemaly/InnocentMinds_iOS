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
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.SearchTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.SearchTableViewCell)
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SearchTableViewCell) as? SearchTableViewCell {
            cell.initializeViews()
            
            cell.imageViewProfile.image = #imageLiteral(resourceName: "avatar_baby")
            cell.labelName.text = "Maya Nehme \(indexPath.row)"
            cell.labelClass.text = "Class \(indexPath.row)-A"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            self.tableView.reloadData()
        }
        
        return true
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.searchTextField.text = nil
        
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
