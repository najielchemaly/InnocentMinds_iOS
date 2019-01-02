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
    
    var statementOfAccount: StatementOfAccount = StatementOfAccount()
    var payments: [Payment] = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getStatementOfAccount()
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
        
        self.buttonPayments.isSelected = true
        
        self.labelTotal.text = nil
    }
    
    func getStatementOfAccount() {
        self.showLoader()
        
        let userId = Objects.user.id ?? "0"
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.getStatementOfAccount(id: userId)
            
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = result?.json?.first {
                        guard let statementOfAccount = StatementOfAccount.init(dictionary: json) else {
                            return
                        }
                        
                        self.statementOfAccount = statementOfAccount
                        
                        if let payments = statementOfAccount.payments {
                            self.payments = payments
                        }
                        
                        if let totalAmount = statementOfAccount.total_amount, totalAmount > 0 {
                            self.labelTotal.text = "\(totalAmount)"
                        }
                    }
                    
                    self.tableView.reloadData()
                } else if let message = result?.message {
                    self.showAlertView(message: message, isError: true)
                } else {
                    self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                }
                
                self.hideLoader()
            }
        }
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.PaymentTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.PaymentTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.EmptyDataTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.EmptyDataTableViewCell)
        self.tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payments.count == 0 ? 1 : self.payments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.payments.count == 0 ? tableView.frame.height : 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.payments.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.EmptyDataTableViewCell) as? EmptyDataTableViewCell {
                cell.labelTitle.text = Localization.string(key: MessageKey.NoPayments)
                cell.labelTitle.textColor = Colors.textDark
                
                return cell
            }
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.PaymentTableViewCell) as? PaymentTableViewCell {
            cell.initializeViews()
            
            let payment = self.payments[indexPath.row]

            let filteredChildren = Objects.user.children?.filter { $0.id == payment.child_id }
            if let child = filteredChildren?.first {
                if let image = child.image, !image.isEmpty {
                    cell.imageViewProfile.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
                } else {
                    cell.imageViewProfile.image = #imageLiteral(resourceName: "boy_avatar").withRenderingMode(.alwaysTemplate)
                }

                if let firstName = child.firstname, let lastName = child.lastname {
                    cell.labelName.text = "\(firstName) \(lastName)"
                }
            }
            
            cell.labelAmountTitle.text = self.buttonPayments.isSelected ? "Payment amount" : "Fee amount"
            cell.labelDateTitle.text = self.buttonPayments.isSelected ? "Payment date" : "Due date"
            
            cell.labelAmount.text = payment.amount
            cell.labelDate.text = payment.date
            
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
