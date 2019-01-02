//
//  EditChildProfileViewController.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/12/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class EditChildProfileViewController: BaseViewController, FSPagerViewDelegate, FSPagerViewDataSource, ImagePickerDelegate {
    
    @IBOutlet weak var pagerView: PagerView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    var currentIndex = 0
    var numberOfPages = 4
    
    var selectedChildIndex = 0
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
        
        self.imagePickerDelegate = self
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
        return numberOfPages
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        switch index {
        case 0:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.PersonalInformationCollectionViewCell, at: index) as? PersonalInformationCollectionViewCell {
                cell.initializeViews()
                
                if let image = self.selectedChild.image, !image.isEmpty {
                    cell.imageViewProfile?.kf.setImage(with: URL(string: Services.getMediaUrl()+image))
                } else if let _image = self.selectedChild._image {
                    cell.imageViewProfile.image = _image
                }
                
                cell.buttonAddImage.isHidden = cell.imageViewProfile.image != nil
                
                cell.textFieldFirstname.text = self.selectedChild.firstname
                cell.textFieldFathername.text = Objects.user.fullname
                cell.textFieldLastname.text = self.selectedChild.lastname
                cell.textFieldGender.text = self.selectedChild.getGender()
                cell.textFieldDateOfBirth.text = self.selectedChild.date_of_birth
                cell.textFieldPlaceOfBirth.text = self.selectedChild.place_of_birth
                cell.textFieldHomeLanguage.text = self.selectedChild.getHomeLanguage()
                cell.textFieldProgramLanguage.text = self.selectedChild.getDesiredLanguage()
                cell.textFieldTransportation.text = self.selectedChild.getTransportation()
                
                cell.buttonAddImage.addTarget(self, action: #selector(self.handleCameraTap), for: .touchUpInside)
                cell.buttonChangeImage.addTarget(self, action: #selector(self.handleCameraTap), for: .touchUpInside)
                
                return cell
            }
//        case 1:
//            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.SchoolBusCollectionViewCell, at: index) as? SchoolBusCollectionViewCell {
//                cell.initializeViews()
//
//                return cell
//            }
        case 1:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.PediatricianCollectionViewCell, at: index) as? PediatricianCollectionViewCell {
                cell.initializeViews()
                
                cell.textFieldFullname.text = self.selectedChild.ped_fullname
                cell.textFieldWorkPlace.text = self.selectedChild.ped_workplace
                cell.textFieldPhone.text = self.selectedChild.ped_phone
                cell.textFieldEmail.text = self.selectedChild.ped_email
                
                return cell
            }
        case 2:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.MedicalInfoCollectionViewCell, at: index) as? MedicalInfoCollectionViewCell {
                cell.initializeViews()
                
                cell.textFieldBloodType.text = self.selectedChild.getBloodType()
                cell.textFieldAllergy.text = self.selectedChild.allergy == nil ? "No" : "Yes"
                cell.textViewAllergy.text = self.selectedChild.allergy ?? cell.textViewAllergy.text
                cell.textFieldRegularMedications.text = self.selectedChild.regular_medication == nil ? "No" : "Yes"
                cell.textViewRegularMedications.text = self.selectedChild.regular_medication ?? cell.textViewRegularMedications.text
                cell.textViewSpecialMedicalConditions.text = self.selectedChild.special_medical_conditions ?? cell.textViewSpecialMedicalConditions.text
                cell.buttonDesease.setTitle(self.selectedChild.disease_ids ?? "Diseases", for: .normal)
                
                return cell
            }
        case 3:
            if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.HabitsTableViewCell, at: index) as? HabitsTableViewCell {
                cell.initializeViews()
                
                cell.textFieldSleepHabit.text = self.selectedChild.getSleepHabit()
                cell.textFieldEatingHabit.text = self.selectedChild.getEatingHabit()
                cell.textFieldClean.text = self.selectedChild.clean
                cell.textFieldCharacter.text = self.selectedChild.getCharacterType()
                
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
            } else if self.currentIndex < self.numberOfPages-1 {
                self.buttonNext.setTitle("Next", for: .normal)
            }
        }
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        if self.validateData() {
            if self.currentIndex < self.numberOfPages-1 {
                self.currentIndex += 1
                
                self.pagerView.scrollToItem(at: self.currentIndex, animated: true)
                
                if self.currentIndex == 1 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.buttonBack.alpha = 1
                    })
                } else if self.currentIndex == self.numberOfPages-1 {
                    self.buttonNext.setTitle("Finish", for: .normal)
                }
            } else {
                self.editChildProfile()
            }
        } else {
            self.showAlertView(message: errorMessage, isError: true)
        }
    }
    
    func editChildProfile() {
        self.showLoader()
        
        let userId = Objects.user.id ?? "0"
        // TODO Dummy
        self.selectedChild.id = self.selectedChild.id ?? "0"
        
        DispatchQueue.global(qos: .background).async {
            let result = appDelegate.services.editChild(id: userId, child: self.selectedChild)
            
            DispatchQueue.main.async {
                if result?.status == ResponseStatus.SUCCESS.rawValue {
                    if let message = result?.message {
                        self.showAlertView(message: message, dismiss: true)
                    } else {
                        self.showAlertView(message: Localization.string(key: MessageKey.EditChildProfile), dismiss: true)
                    }
                    
                    Objects.user.children?[self.selectedChildIndex] = self.selectedChild
                } else {
                    if let message = result?.message {
                        self.showAlertView(message: message, isError: true)
                    } else {
                        self.showAlertView(message: Localization.string(key: MessageKey.InternalServerError), isError: true)
                    }
                }
                
                self.hideLoader()
            }
        }
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    var errorMessage: String = ""
    func validateData() -> Bool {
        // TODO Dummy
        return true
        switch currentIndex {
        case 0:
            if self.selectedChild.firstname.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.FirstNameEmpty)
                return false
            } else if self.selectedChild.fathername.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.FatherNameEmpty)
                return false
            } else if self.selectedChild.lastname.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.LastNameEmpty)
                return false
            } else if self.selectedChild.gender_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.GenderEmpty)
                return false
            } else if self.selectedChild.date_of_birth.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.DateOfBirthEmpty)
                return false
            } else if self.selectedChild.place_of_birth.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.PlaceOfBirthEmpty)
                return false
            } else if self.selectedChild.home_language_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.HomeLanguageEmpty)
                return false
            } else if self.selectedChild.desired_language_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.DesiredLanguageEmpty)
                return false
            } else if self.selectedChild.transp_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.TransportationEmpty)
                return false
            }
//        case 1:
//            return true
        case 1:
            if self.selectedChild.ped_fullname.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.NameEmpty)
                return false
            } else if self.selectedChild.ped_workplace.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.WorkplaceEmpty)
                return false
            } else if self.selectedChild.ped_phone.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.PhoneEmpty)
                return false
            } else if self.selectedChild.ped_email.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.EmailEmpty)
                return false
            }
        case 2:
            if self.selectedChild.blood_type_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.BloodTypeEmpty)
                return false
            } else if self.selectedChild.allergy.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.AllergyEmpty)
                return false
            } else if self.selectedChild.regular_medication.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.RegularMedicationEmpty)
                return false
            } else if self.selectedChild.disease_ids.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.DiseaseEmpty)
                return false
            } else if self.selectedChild.special_medical_conditions.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.SpecialMedicationConditionsEmpty)
                return false
            }
        case 3:
            if self.selectedChild.sleep_habit_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.SleepHabitEmpty)
                return false
            } else if self.selectedChild.eating_habit_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.EatingHabitEmpty)
                return false
            } else if self.selectedChild.clean.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.CleanEmpty)
                return false
            } else if self.selectedChild.character_type_id.isNullOrEmpty() {
                errorMessage = Localization.string(key: MessageKey.CharacterEmpty)
                return false
            }
        default:
            break
        }
        
        return true
    }
    
    func didFinishPickingMedia(data: UIImage?) {
        if let image = data {
            self.selectedChild._image = image
            self.pagerView.reloadData()
        }
    }
    
    func didCancelPickingMedia() {
        
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
