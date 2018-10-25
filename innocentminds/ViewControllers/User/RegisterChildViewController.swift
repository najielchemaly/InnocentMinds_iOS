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
    
    var currentIndex = 0
    var tempUser: User = User()
    
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
        self.showLoader()
        
        let roleId = currentUser.role_id == nil ? "0" : currentUser.role_id!
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.registerChild(user: self.tempUser, roleId: roleId)
            
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue {
                    if let id = Int(roleId), id > 0 {
                        if let message = result?.message {
                            self.showAlertView(message: message, dismiss: true)
                        } else {
                            self.showAlertView(message: Localization.string(key: MessageKey.RegisterComplete), dismiss: true)
                        }
                    }
                } else if let message = result?.message {
                    self.showAlertView(message: message)
                } else {
                    self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError))
                }
                
                self.hideLoader()
            }
        }
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
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
        if self.validateData() {
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
            self.showAlertView(message: errorMessage)
        }
    }
    
    var errorMessage: String = ""
    func validateData() -> Bool {
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
                if tempUser.fullname.isNullOrEmpty() {
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
        
        if let roleId = currentUser.role_id, roleId == UserRole.Secretary.rawValue {
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
                
                return cell
            }
        case 1:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.RegisterChildStep2CollectionViewCell, at: index) as? RegisterChildStep2CollectionViewCell {
                cell.initializeViews()
                
                return cell
            }
        case 2:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.RegisterChildStep3CollectionViewCell, at: index) as? RegisterChildStep3CollectionViewCell {
                cell.initializeViews()
                
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
