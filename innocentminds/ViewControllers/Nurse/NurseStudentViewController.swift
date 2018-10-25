//
//  NurseStudentViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 9/3/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class NurseStudentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelNurseName: UILabel!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
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
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.showAlertView(message: Localization.string(key: MessageKey.Logout), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
        
        if let alertView = self.customView as? AlertView {
            alertView.buttonOk.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    func initializeViews() {
        self.buttonBack.imageView?.contentMode = .scaleAspectFit
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.NurseStudentTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.NurseStudentTableViewCell)
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.NurseStudentTableViewCell) as? NurseStudentTableViewCell {
            cell.selectionStyle = .none
            cell.initializeViews()
            
            let cellTap = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:)))
            cell.addGestureRecognizer(cellTap)
            cell.tag = indexPath.row
            
            cell.imageViewProfile.image = #imageLiteral(resourceName: "avatar_baby")
            cell.labelStudentName.text = "Maya Nehme"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        if let cell = sender.view {
            self.redirectToVC(storyboard: nurseStoryboard, storyboardId: StoryboardIds.NurseStudentDetailViewController, type: .push)
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
