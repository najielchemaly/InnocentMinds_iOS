//
//  PaymentViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/2/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewStack: UIView!
    @IBOutlet weak var buttonPayments: UIButton!
    @IBOutlet weak var buttonFees: UIButton!
    @IBOutlet weak var labelTotal: UILabel!
    
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
        self.viewStack.layer.borderWidth = 1
        self.viewStack.layer.borderColor = Colors.lightGray.cgColor
        self.viewStack.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonPayments.layer.cornerRadius = Dimensions.cornerRadiusNormal
        self.buttonFees.layer.cornerRadius = Dimensions.cornerRadiusNormal
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.PaymentTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.PaymentTableViewCell)
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.PaymentTableViewCell) as? PaymentTableViewCell {
            cell.initializeViews()
            
            cell.imageViewProfile.image = #imageLiteral(resourceName: "avatar_baby")
            cell.labelName.text = "Maya Nehme \(indexPath.row)"
            
            cell.labelAmountTitle.text = self.buttonPayments.isSelected ? "Payment amount" : "Fee amount"
            cell.labelDateTitle.text = self.buttonPayments.isSelected ? "Payment date" : "Due date"
            
            cell.labelAmount.text = "$500"
            cell.labelDate.text = "Monday, September 30, 2018"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func buttonSegmentTapped(_ sender: Any) {
        if let button = sender as? UIButton, !button.isSelected {
            self.buttonPayments.isSelected = button == self.buttonPayments ? true : false
            self.buttonFees.isSelected = button == self.buttonFees ? true : false
            
            self.buttonPayments.backgroundColor = self.buttonPayments.isSelected ? Colors.lightGray : Colors.white
            self.buttonFees.backgroundColor = self.buttonFees.isSelected ? Colors.lightGray : Colors.white
            
            self.tableView.reloadData()
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
