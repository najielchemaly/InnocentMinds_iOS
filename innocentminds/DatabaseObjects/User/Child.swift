/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Child {
	public var id : String?
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
	public var activities : Array<Activity>?

    public init() {}
    
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

		id = dictionary["id"] as? String
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
		if (dictionary["activities"] != nil) { activities = Activity.modelsFromDictionaryArray(array: dictionary["activities"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
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
        dictionary.setValue(self.activities, forKey: "activities")

		return dictionary
	}

}
