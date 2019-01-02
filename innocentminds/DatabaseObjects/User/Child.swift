/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import UIKit
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Child: JSONable {
	public var id : String?
    public var parent_id : String?
    public var is_born : Bool?
	public var firstname : String?
    public var fathername : String?
	public var lastname : String?
	public var date_of_birth : String?
    public var desired_date_of_entry : String?
	public var class_id : String?
	public var gender_id : String?
	public var image : String?
	public var place_of_birth : String?
	public var branch_id : String?
	public var ped_fullname : String?
	public var ped_workplace : String?
	public var ped_phone : String?
	public var ped_email : String?
	public var transp_id : String?
	public var blood_type_id : String?
	public var allergy : String?
	public var regular_medication : String?
	public var disease_ids : String?
	public var special_medical_conditions : String?
	public var sleep_habit_id : String?
	public var eating_habit_id : String?
	public var clean : String?
	public var pacifier : String?
	public var character_type_id : String?
    public var home_language_id : String?
    public var desired_language_id : String?
    public var hear_about_us_id : String?
	public var activities : Array<Activity>?
    public var _image : UIImage?
    public var has_arrived: Bool?
    public var date_arrived: String?
    public var child_temps: Array<ChildTemperature>?

    public init() {}
    
    public func getBranch() -> String? {
        guard let branchId = branch_id else {
            return nil
        }
        
        guard let branches = Objects.variables.branches else {
            return nil
        }
        
        let branch = branches.first { $0.id == branchId }
        return branch == nil ? branch_id : branch?.title
    }
    
    public func getHeadAboutUs() -> String? {
        guard let hearAboutUsId = hear_about_us_id else {
            return nil
        }
        
        guard let hearAboutUss = Objects.variables.hear_about_us else {
            return nil
        }
        
        let hearAboutUs = hearAboutUss.first { $0.id == hearAboutUsId }
        return hearAboutUs == nil ? hear_about_us_id : hearAboutUs?.title
    }
    
    public func getGender() -> String? {
        guard let genderId = gender_id else {
            return nil
        }
        
        guard let genders = Objects.variables.genders else {
            return nil
        }
        
        let gender = genders.first { $0.id == genderId }
        return gender == nil ? gender_id : gender?.title
    }
    
    public func getHomeLanguage() -> String? {
        guard let homeLanguageId = home_language_id else {
            return nil
        }
        
        guard let homeLanguages = Objects.variables.home_languages else {
            return nil
        }
        
        let homeLangugage = homeLanguages.first { $0.id == homeLanguageId }
        return homeLangugage == nil ? home_language_id : homeLangugage?.title
    }
    
    public func getDesiredLanguage() -> String? {
        guard let desiredLanguageId = desired_language_id else {
            return nil
        }
        
        guard let desiredLanguages = Objects.variables.program_languages else {
            return nil
        }
        
        let desiredLanguage = desiredLanguages.first { $0.id == desiredLanguageId }
        return desiredLanguage == nil ? desired_language_id : desiredLanguage?.title
    }
    
    public func getTransportation() -> String? {
        guard let transpId = transp_id else {
            return nil
        }
        
        guard let transportations = Objects.variables.transportations else {
            return nil
        }
        
        let transportation = transportations.first { $0.id == transpId }
        return transportation == nil ? transp_id : transportation?.title
    }
    
    public func getBloodType() -> String? {
        guard let bloodTypeId = blood_type_id else {
            return nil
        }
        
        guard let bloodTypes = Objects.variables.blood_types else {
            return nil
        }
        
        let bloodType = bloodTypes.first { $0.id == bloodTypeId }
        return bloodType == nil ? blood_type_id : bloodType?.title
    }
    
    public func getSleepHabit() -> String? {
        guard let sleepHabitId = sleep_habit_id else {
            return nil
        }
        
        guard let habitRanks = Objects.variables.habit_ranks else {
            return nil
        }
        
        let habitRank = habitRanks.first { $0.id == sleepHabitId }
        return habitRank == nil ? sleep_habit_id : habitRank?.title
    }
    
    public func getEatingHabit() -> String? {
        guard let eatingHabitId = eating_habit_id else {
            return nil
        }
        
        guard let habitRanks = Objects.variables.habit_ranks else {
            return nil
        }
        
        let habitRank = habitRanks.first { $0.id == eatingHabitId }
        return habitRank == nil ? eating_habit_id : habitRank?.title
    }
    
    public func getCharacterType() -> String? {
        guard let characterTypeId = character_type_id else {
            return nil
        }
        
        guard let characterTypes = Objects.variables.character_types else {
            return nil
        }
        
        let characterType = characterTypes.first { $0.id == characterTypeId }
        return characterType == nil ? character_type_id : characterType?.title
    }
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let children_list = Child.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Child Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Child]
    {
        var models:[Child] = []
        for item in array
        {
            models.append(Child(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let children = Child(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Child Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if let id = dictionary["id"] as? String {
            self.id = id
        } else if let id = dictionary["id"] as? Int {
            self.id = "\(id)"
        }
        if let parent_id = dictionary["parent_id"] as? String {
            self.parent_id = parent_id
        } else if let parent_id = dictionary["parent_id"] as? Int {
            self.parent_id = "\(parent_id)"
        }
        is_born = dictionary["is_born"] as? Bool
		firstname = dictionary["firstname"] as? String
        fathername = dictionary["fathername"] as? String
		lastname = dictionary["lastname"] as? String
		date_of_birth = dictionary["date_of_birth"] as? String
        desired_date_of_entry = dictionary["desired_date_of_entry"] as? String
		class_id = dictionary["class_id"] as? String
		gender_id = dictionary["gender_id"] as? String
		image = dictionary["image"] as? String
		place_of_birth = dictionary["place_of_birth"] as? String
		branch_id = dictionary["branch_id"] as? String
		ped_fullname = dictionary["ped_fullname"] as? String
		ped_workplace = dictionary["ped_workplace"] as? String
		ped_phone = dictionary["ped_phone"] as? String
		ped_email = dictionary["ped_email"] as? String
		transp_id = dictionary["transp_id"] as? String
		blood_type_id = dictionary["blood_type_id"] as? String
		allergy = dictionary["allergy"] as? String
		regular_medication = dictionary["regular_medication"] as? String
		disease_ids = dictionary["disease_ids"] as? String
		special_medical_conditions = dictionary["special_medical_conditions"] as? String
		sleep_habit_id = dictionary["sleep_habit_id"] as? String
		eating_habit_id = dictionary["eating_habit_id"] as? String
		clean = dictionary["clean"] as? String
		pacifier = dictionary["pacifier"] as? String
		character_type_id = dictionary["character_type_id"] as? String
        home_language_id = dictionary["home_language_id"] as? String
        desired_language_id = dictionary["desired_language_id"] as? String
        hear_about_us_id = dictionary["hear_about_us_id"] as? String
        has_arrived = dictionary["has_arrived"] as? Bool
        date_arrived = dictionary["date_arrived"] as? String
		if (dictionary["activities"] != nil) { activities = Activity.modelsFromDictionaryArray(array: dictionary["activities"] as! NSArray) }
        if (dictionary["child_temps"] != nil) { child_temps = ChildTemperature.modelsFromDictionaryArray(array: dictionary["child_temps"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.parent_id, forKey: "parent_id")
        dictionary.setValue(self.is_born, forKey: "is_born")
		dictionary.setValue(self.firstname, forKey: "firstname")
        dictionary.setValue(self.fathername, forKey: "fathername")
		dictionary.setValue(self.lastname, forKey: "lastname")
		dictionary.setValue(self.date_of_birth, forKey: "date_of_birth")
        dictionary.setValue(self.desired_date_of_entry, forKey: "desired_date_of_entry")
		dictionary.setValue(self.class_id, forKey: "class_id")
		dictionary.setValue(self.gender_id, forKey: "gender_id")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.place_of_birth, forKey: "place_of_birth")
		dictionary.setValue(self.branch_id, forKey: "branch_id")
		dictionary.setValue(self.ped_fullname, forKey: "ped_fullname")
		dictionary.setValue(self.ped_workplace, forKey: "ped_workplace")
		dictionary.setValue(self.ped_phone, forKey: "ped_phone")
		dictionary.setValue(self.ped_email, forKey: "ped_email")
		dictionary.setValue(self.transp_id, forKey: "transp_id")
		dictionary.setValue(self.blood_type_id, forKey: "blood_type_id")
		dictionary.setValue(self.allergy, forKey: "allergy")
		dictionary.setValue(self.regular_medication, forKey: "regular_medication")
		dictionary.setValue(self.disease_ids, forKey: "disease_ids")
		dictionary.setValue(self.special_medical_conditions, forKey: "special_medical_conditions")
		dictionary.setValue(self.sleep_habit_id, forKey: "sleep_habit_id")
		dictionary.setValue(self.eating_habit_id, forKey: "eating_habit_id")
		dictionary.setValue(self.clean, forKey: "clean")
		dictionary.setValue(self.pacifier, forKey: "pacifier")
		dictionary.setValue(self.character_type_id, forKey: "character_type_id")
        dictionary.setValue(self.home_language_id, forKey: "home_language_id")
        dictionary.setValue(self.desired_language_id, forKey: "desired_language_id")
        dictionary.setValue(self.hear_about_us_id, forKey: "hear_about_us_id")
        dictionary.setValue(self.activities, forKey: "activities")
        dictionary.setValue(self.has_arrived, forKey: "has_arrived")
        dictionary.setValue(self.date_arrived, forKey: "date_arrived")

		return dictionary
	}

}
