//
//  EditChildProfileViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/12/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class EditChildProfileViewController: BaseViewController, FSPagerViewDelegate, FSPagerViewDataSource {

    @IBOutlet weak var pagerView: PagerView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    var currentIndex = 0
    var numberOfItems = 5
    
    var selectedChildId: String = "0"
    var selectedChild: Child = Child()
    
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
    
    func initializeViews() {
        self.buttonBack.alpha = 0
        self.buttonNext.layer.cornerRadius = self.buttonNext.frame.height/2
    }
    
    func setupPagerView() {
        self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        self.pagerView.register(UINib.init(nibName: CellIds.PersonalInformationCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.PersonalInformationCollectionViewCell)
        self.pagerView.register(UINib.init(nibName: CellIds.SchoolBusCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.SchoolBusCollectionViewCell)
        self.pagerView.register(UINib.init(nibName: CellIds.PediatricianCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.PediatricianCollectionViewCell)
        self.pagerView.register(UINib.init(nibName: CellIds.MedicalInfoCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.MedicalInfoCollectionViewCell)
        self.pagerView.register(UINib.init(nibName: CellIds.HabitsTableViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.HabitsTableViewCell)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return numberOfItems
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        switch index {
        case 0:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.PersonalInformationCollectionViewCell, at: index) as? PersonalInformationCollectionViewCell {
                cell.initializeViews()
                
                return cell
            }
        case 1:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.SchoolBusCollectionViewCell, at: index) as? SchoolBusCollectionViewCell {
                cell.initializeViews()
                
                return cell
            }
        case 2:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.PediatricianCollectionViewCell, at: index) as? PediatricianCollectionViewCell {
                cell.initializeViews()
                
                return cell
            }
        case 3:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.MedicalInfoCollectionViewCell, at: index) as? MedicalInfoCollectionViewCell {
                cell.initializeViews()
                
                return cell
            }
        case 4:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.HabitsTableViewCell, at: index) as? HabitsTableViewCell {
                cell.initializeViews()
                
                return cell
            }
        default:
            return FSPagerViewCell()
        }
        
        return FSPagerViewCell()
    }
    
    @IBAction func buttonBackTapped(_ sender: Any) {
        if self.currentIndex > 0 {
            self.currentIndex -= 1
            
            self.pagerView.scrollToItem(at: self.currentIndex, animated: true)
            
            if self.currentIndex == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.buttonBack.alpha = 0
                })
            } else if self.currentIndex < self.numberOfItems-1 {
                self.buttonNext.setTitle("Next", for: .normal)
            }
        }
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        if self.validateData() {
            if self.currentIndex < self.numberOfItems-1 {
                self.currentIndex += 1
                
                self.pagerView.scrollToItem(at: self.currentIndex, animated: true)
                
                if self.currentIndex == 1 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.buttonBack.alpha = 1
                    })
                } else if self.currentIndex == self.numberOfItems-1 {
                    self.buttonNext.setTitle("Finish", for: .normal)
                }
            }
        } else {
            self.showAlertView(message: errorMessage)
        }
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        
    }
    
    var errorMessage: String = ""
    func validateData() -> Bool {
//        if let child = self.tempUser.children?.first {
//            switch currentIndex {
//            case 0:
//                if child.firstname.isNullOrEmpty() {
//                    errorMessage = Localization.string(key: MessageKey.FirstNameEmpty)
//                    return false
//                } else if child.lastname.isNullOrEmpty() {
//                    errorMessage = Localization.string(key: MessageKey.LastNameEmpty)
//                    return false
//                } else if child.date_of_birth.isNullOrEmpty() && (child.is_born == nil || child.is_born == true) {
//                    errorMessage = Localization.string(key: MessageKey.DateOfBirthEmpty)
//                    return false
//                }
//            case 1:
//                if tempUser.fullname.isNullOrEmpty() {
//                    errorMessage = Localization.string(key: MessageKey.NameEmpty)
//                    return false
//                } else if tempUser.phone.isNullOrEmpty() {
//                    errorMessage = Localization.string(key: MessageKey.PhoneEmpty)
//                    return false
//                } else if tempUser.email.isNullOrEmpty() {
//                    errorMessage = Localization.string(key: MessageKey.EmailEmpty)
//                    return false
//                } else if tempUser.address.isNullOrEmpty() {
//                    errorMessage = Localization.string(key: MessageKey.AddressEmpty)
//                    return false
//                }
//            default:
//                break
//            }
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
