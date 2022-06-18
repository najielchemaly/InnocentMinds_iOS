//
//  MessageDetailsViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/27/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit

class MessageDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldMessage: UITextField!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var messages: [Message] = [
        Message.init(type: MessageDetailType.Opponent.identifier, desc: "Hello John, we are please to inform you that your daugther is making better progress since our last discussion.", date: "May 2, 2018 5:30 PM"),
        Message.init(type: MessageDetailType.User.identifier, desc: "Hi, is the nurserie open tomorrow?", date: "May 3, 2018 10:15 AM"),
        Message.init(type: MessageDetailType.Opponent.identifier, desc: "Hey there John, yes we are open tomorrow.", date: "May 3, 2018 11:25 AM")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupKeyboardObservers()
        self.initializeViews()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if textFieldMessage.isFirstResponder {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                self.viewBottomConstraint.constant = -keyboardRectangle.height
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.viewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func initializeViews() {
        self.navigationController?.navigationBar.tintColor = Colors.appRed
        self.navigationController?.navigationBar.backgroundColor = Colors.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.buttonSend.isEnabled(enable: false)
    }
    
    func setupTableView() {
        self.tableView.register(UINib.init(nibName: CellIds.MessageOpponentTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.MessageOpponentTableViewCell)
        self.tableView.register(UINib.init(nibName: CellIds.MessageMeTableViewCell, bundle: nil), forCellReuseIdentifier: CellIds.MessageMeTableViewCell)
        
        self.tableView.tableFooterView = UIView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)
    }
    
    var messageId = 0
    @IBAction func buttonSendTapped(_ sender: Any) {
        if let text = self.textFieldMessage.text, !text.replacingOccurrences(of: " ", with: "").isEmpty {
            let type = messageId % 2 == 0 ? MessageDetailType.User.identifier : MessageDetailType.Opponent.identifier
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy mm:ss a"
            let dateString = formatter.string(from: date)
            let message = Message.init(type: type, desc: text, date: dateString)
            self.messages.append(message)
            
            self.textFieldMessage.text = nil
            self.messageId += 1
            
            self.tableView.reloadData()
            self.dismissKeyboard()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.type == MessageDetailType.Opponent.identifier {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.MessageOpponentTableViewCell) as? MessageOpponentTableViewCell {
                cell.selectionStyle = .none
                cell.initializeViews()

                cell.labelDescription.text = message.desc
                cell.labelDate.text = message.date
                
                return cell
            }
        } else if message.type == MessageDetailType.User.identifier {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.MessageMeTableViewCell) as? MessageMeTableViewCell {
                cell.selectionStyle = .none
                cell.initializeViews()
                
                cell.labelDescription.text = message.desc
                cell.labelDate.text = message.date
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = textField.text, !text.replacingOccurrences(of: " ", with: "").isEmpty {
//            self.buttonSend.isEnabled(enable: true)
//        } else {
//            self.buttonSend.isEnabled(enable: false)
//        }
        
        return true
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

private class Message {
    var type: String!
    var desc: String!
    var date: String!
    
    init(type: String, desc: String, date: String) {
        self.type = type
        self.desc = desc
        self.date = date
    }
}
