//
//  HabitsTableViewCell.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/15/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import UIKit
import FSPagerView

class HabitsTableViewCell: FSPagerViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldSleepHabit: UITextField!
    @IBOutlet weak var textFieldEatingHabit: UITextField!
    @IBOutlet weak var textFieldClean: UITextField!
    @IBOutlet weak var textViewTetine: UITextView!
    @IBOutlet weak var textFieldCharacter: UITextField!
    
    var pickerView: UIPickerView!
    
    var habitRanks: [HabitRank] = [HabitRank]()
    var characterTypes: [CharacterType] = [CharacterType]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeViews() {
        self.contentView.layer.shadowRadius = 0
        
        for view in self.scrollView.subviews {
            view.customizeView()
        }
        
        if let habitRanks = Objects.variables.habit_ranks {
            self.habitRanks = habitRanks
        }
        
        if let characterTypes = Objects.variables.character_types {
            self.characterTypes = characterTypes
        }
        
        self.setupDelegates()
        self.setupPickerViews()
    }
    
    func setupDelegates() {
        self.textViewTetine.delegate = self
    }
    
    func setupPickerViews() {
        if let baseVC = currentVC as? BaseViewController {
            self.pickerView = UIPickerView()
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            
            self.textFieldSleepHabit.inputView = self.pickerView
            self.textFieldEatingHabit.inputView = self.pickerView
            self.textFieldClean.inputView = self.pickerView
            self.textFieldCharacter.inputView = self.pickerView
            
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: baseVC.view.frame.width, height: 44))
            toolbar.sizeToFit()
            toolbar.barStyle = .default
            let cancelButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Cancel), style: .plain, target: baseVC, action: #selector(baseVC.dismissKeyboard))
            cancelButton.tintColor = Colors.appBlue
            let doneButton = UIBarButtonItem(title: Localization.string(key: MessageKey.Done), style: .plain, target: self, action: #selector(self.doneButtonTapped))
            doneButton.tintColor = Colors.appBlue
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            toolbar.items = [cancelButton, flexibleSpace, doneButton]
            
            self.textFieldSleepHabit.inputAccessoryView = toolbar
            self.textFieldEatingHabit.inputAccessoryView = toolbar
            self.textFieldClean.inputAccessoryView = toolbar
            self.textFieldCharacter.inputAccessoryView = toolbar
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.textFieldSleepHabit.isFirstResponder || self.textFieldEatingHabit.isFirstResponder {
            return self.habitRanks.count
        } else if self.textFieldClean.isFirstResponder {
            return Objects.answers.count
        } else if self.textFieldCharacter.isFirstResponder {
            return self.characterTypes.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.textFieldSleepHabit.isFirstResponder || self.textFieldEatingHabit.isFirstResponder {
            return self.habitRanks[row].title
        } else if self.textFieldClean.isFirstResponder {
            return Objects.answers[row]
        } else if self.textFieldCharacter.isFirstResponder {
            return self.characterTypes[row].title
        }
        
        return nil
    }
    
    @objc func doneButtonTapped() {
        if let editChildProfileVC = currentVC as? EditChildProfileViewController {
            let row = self.pickerView.selectedRow(inComponent: 0)
            if self.textFieldSleepHabit.isFirstResponder {
                self.textFieldSleepHabit.text = self.habitRanks[row].title
                editChildProfileVC.selectedChild.sleep_habit_id = self.habitRanks[row].id
            } else if self.textFieldEatingHabit.isFirstResponder {
                self.textFieldEatingHabit.text = self.habitRanks[row].title
                editChildProfileVC.selectedChild.eating_habit_id = self.habitRanks[row].id
            } else if self.textFieldClean.isFirstResponder {
                self.textFieldClean.text = Objects.answers[row]
                editChildProfileVC.selectedChild.clean = Objects.answers[row]
            } else if self.textFieldCharacter.isFirstResponder {
                self.textFieldCharacter.text = self.characterTypes[row].title
                editChildProfileVC.selectedChild.character_type_id = self.characterTypes[row].id
            }
            
            editChildProfileVC.dismissKeyboard()
        }
    }
    
}
