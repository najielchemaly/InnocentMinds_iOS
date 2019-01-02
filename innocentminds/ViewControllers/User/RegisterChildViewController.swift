//
//  RegisterChildViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 8/23/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class RegisterChildViewController: BaseViewController, FSPagerViewDelegate, FSPagerViewDataSource {
    
    @IBOutlet weak var pagerView: PagerView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonRequestAppointment: UIButton!
    @IBOutlet weak var stackViewRequest: UIStackView!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var currentIndex = 0
    var tempUser: User = User()
    var mode: RegisterMode = .request
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupPagerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonRequestAppointmentTapped(_ sender: Any) {
        if isValidData() {
            self.showLoader()
            
            let roleId = Objects.user.role_id == nil ? "1" : Objects.user.role_id!
            let isRequest = self.mode == .request
            
            DispatchQueue.global(qos: .background).async {
                let result = appDelegate.services.registerChild(user: self.tempUser, roleId: roleId, isRequest: isRequest)
                
                DispatchQueue.main.async {
                    if result?.status == ResponseStatus.SUCCESS.rawValue {
                        if let id = Int(roleId), id > 0 {
                            if let message = result?.message {
                                self.showAlertView(message: message, dismiss: true)
                            } else {
                                self.showAlertView(message: Localization.string(key: MessageKey.RegisterComplete), dismiss: true)
                            }
                        }
                        
                        self.resetChildInformation()
                    } else if let message = result?.message {
                        self.showAlertView(message: message, isError: true)
                    } else {
                        self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                    }
                    
                    self.hideLoader()
                }
            }
        } else {
            self.showAlertView(message: errorMessage, isError: true)
        }
    }
    
    func resetChildInformation() {
        self.tempUser = User()
        self.pagerView.reloadData()
        self.pagerView.scrollToItem(at: 0, animated: true)
        self.currentIndex = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.stackView.alpha = 1
            self.stackViewRequest.alpha = 0
            self.buttonBack.alpha = 0
        })
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        if let roleId = Objects.user.role_id, roleId == UserRole.Secretary.rawValue {
            self.showAlertView(message: Localization.string(key: MessageKey.MainMenuValidation), buttonOkTitle: Localization.string(key: MessageKey.Yes), buttonCancelTitle: Localization.string(key: MessageKey.Cancel), logout: true)
            
            if let alertView = self.customView as? AlertView {
                alertView.buttonOk.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
            }
        } else {
            self.dismissVC()
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        if currentIndex > 0 {
            currentIndex -= 1
            
            pagerView.scrollToItem(at: currentIndex, animated: true)
            
            if currentIndex == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.buttonBack.alpha = 0
                })
            } else if currentIndex == 1 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.stackView.alpha = 1
                    self.stackViewRequest.alpha = 0
                })
            }
        }
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        if self.isValidData() {
            if currentIndex < 2 {
                currentIndex += 1
                
                pagerView.scrollToItem(at: currentIndex, animated: true)
                
                if currentIndex == 1 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.buttonBack.alpha = 1
                    })
                } else if currentIndex == 2 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.stackView.alpha = 0
                        self.stackViewRequest.alpha = 1
                    })
                }
            }
        } else {
            self.showAlertView(message: errorMessage, isError: true)
        }
    }
    
    var errorMessage: String = ""
    func isValidData() -> Bool {
        if let child = self.tempUser.children?.first {
            switch currentIndex {
            case 0:
                if child.firstname.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.FirstNameEmpty)
                    return false
                } else if child.lastname.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.LastNameEmpty)
                    return false
                } else if child.date_of_birth.isNullOrEmpty() && (child.is_born == nil || child.is_born == true) {
                    errorMessage = Localization.string(key: MessageKey.DateOfBirthEmpty)
                    return false
                }
            case 1:
                if tempUser.parent_type.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.ParentEmpty)
                    return false
                } else if tempUser.fullname.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.NameEmpty)
                    return false
                } else if tempUser.phone.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.PhoneEmpty)
                    return false
                } else if tempUser.email.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.EmailEmpty)
                    return false
                } else if tempUser.address.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.AddressEmpty)
                    return false
                }
            case 2:
                if child.desired_date_of_entry.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.DesiredDateEmpty)
                    return false
                } else if child.branch_id.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.BranchEmpty)
                    return false
                } else if child.hear_about_us_id.isNullOrEmpty() {
                    errorMessage = Localization.string(key: MessageKey.HearAboutUsEmpty)
                    return false
                }
            default:
                break
            }
        }
        
        return true
    }
    
    func initializeViews() {
        self.buttonRequestAppointment.layer.cornerRadius = self.buttonRequestAppointment.frame.height/2
        self.buttonBack.layer.cornerRadius = self.buttonBack.frame.height/2
        self.buttonNext.layer.cornerRadius = self.buttonNext.frame.height/2
        self.buttonBack.alpha = 0
        
        self.tempUser.children = [Child()]
        
        if let roleId = Objects.user.role_id, roleId == UserRole.Secretary.rawValue {
            self.buttonRequestAppointment.setTitle(Localization.string(key: MessageKey.Register), for: .normal)
            self.buttonCancel.setTitle(Localization.string(key: MessageKey.Logout), for: .normal)
        } else if self.mode == .add {
            self.buttonRequestAppointment.setTitle(Localization.string(key: MessageKey.Register), for: .normal)
        }
    }
    
    func setupPagerView() {
        self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        self.pagerView.register(UINib.init(nibName: CellIds.RegisterChildStep1CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.RegisterChildStep1CollectionViewCell)
        self.pagerView.register(UINib.init(nibName: CellIds.RegisterChildStep2CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.RegisterChildStep2CollectionViewCell)
        self.pagerView.register(UINib.init(nibName: CellIds.RegisterChildStep3CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.RegisterChildStep3CollectionViewCell)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        switch index {
        case 0:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.RegisterChildStep1CollectionViewCell, at: index) as? RegisterChildStep1CollectionViewCell {
                cell.initializeViews()
                
                if let child = self.tempUser.children?.first {
                    cell.textFieldFirstName.text = child.firstname
                    cell.textFieldLastName.text = child.lastname
                    cell.textFieldDateOfBirth.text = child.date_of_birth
                } else {
                    cell.textFieldFirstName.text = nil
                    cell.textFieldLastName.text = nil
                    cell.textFieldDateOfBirth.text = nil
                }
                
                return cell
            }
        case 1:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.RegisterChildStep2CollectionViewCell, at: index) as? RegisterChildStep2CollectionViewCell {
                cell.initializeViews()
                
                if let roleId = Objects.user.role_id, roleId == UserRole.Parent.rawValue {
                    cell.textFieldName.text = Objects.user.fullname
                    cell.textFieldPhone.text = Objects.user.phone
                    cell.textFieldEmail.text = Objects.user.email
                    cell.textFieldAddress.text = Objects.user.address
                    
                    if Objects.user.parent_type == ParentType.Father.rawValue {
                        cell.setButtonFatherSelected()
                    } else if Objects.user.parent_type == ParentType.Mother.rawValue {
                        cell.setButtonMotherSelected()
                    }
                } else {
                    cell.textFieldName.text = self.tempUser.fullname
                    cell.textFieldPhone.text = self.tempUser.phone
                    cell.textFieldEmail.text = self.tempUser.email
                    cell.textFieldAddress.text = self.tempUser.address
                }
                
                return cell
            }
        case 2:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.RegisterChildStep3CollectionViewCell, at: index) as? RegisterChildStep3CollectionViewCell {
                cell.initializeViews()
                
                if let child = self.tempUser.children?.first {
                    cell.textFieldDateOfEntry.text = child.desired_date_of_entry
                    cell.textFieldBranch.text = child.getBranch()
                    cell.textFieldHearAboutUs.text = child.getHeadAboutUs()
                } else {
                    cell.textFieldDateOfEntry.text = nil
                    cell.textFieldBranch.text = nil
                    cell.textFieldHearAboutUs.text = nil
                }
                
                return cell
            }
        default:
            return FSPagerViewCell()
        }
        
        return FSPagerViewCell()
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
