/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Variables {
    public var message : String?
    public var status : Int?
	public var config : Config?
    public var branches : Array<Branch>?
	public var hear_about_us : Array<HearAboutUs>?
	public var about : About?
	public var contacts : Array<Contact>?
	public var messages : Array<Messages>?
    public var genders : Array<Gender>?
    public var home_languages : Array<HomeLanguage>?
    public var program_languages : Array<ProgramLanguage>?
    public var transportations : Array<Transportation>?
    public var blood_types : Array<BloodType>?
    public var habit_ranks : Array<HabitRank>?
    public var diseases : Array<Disease>?
    public var character_types : Array<CharacterType>?
    public var bath_types : Array<BathType>?
    public var bath_potty_types : Array<BathPottyType>?

    public init() {}
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Config_list = Variables.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Variables Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Variables]
    {
        var models:[Variables] = []
        for item in array
        {
            models.append(Variables(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Variables = Variables(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Variables Instance.
*/
	required public init?(dictionary: NSDictionary) {

        message = dictionary["message"] as? String
        status = dictionary["status"] as? Int
        if (dictionary["config"] != nil) { config = Config(dictionary: dictionary["config"] as! NSDictionary) }
        if (dictionary["branches"] != nil) { branches = Branch.modelsFromDictionaryArray(array: dictionary["branches"] as! NSArray) }
		if (dictionary["hear_about_us"] != nil) { hear_about_us = HearAboutUs.modelsFromDictionaryArray(array: dictionary["hear_about_us"] as! NSArray) }
		if (dictionary["about"] != nil) { about = About(dictionary: dictionary["about"] as! NSDictionary) }
		if (dictionary["contact"] != nil) { contacts = Contact.modelsFromDictionaryArray(array: dictionary["contact"] as! NSArray) }
		if (dictionary["messages"] != nil) { messages = Messages.modelsFromDictionaryArray(array: dictionary["messages"] as! NSArray) }
        if (dictionary["genders"] != nil) { genders = Gender.modelsFromDictionaryArray(array: dictionary["genders"] as! NSArray) }
        if (dictionary["home_languages"] != nil) { home_languages = HomeLanguage.modelsFromDictionaryArray(array: dictionary["home_languages"] as! NSArray) }
        if (dictionary["program_languages"] != nil) { program_languages = ProgramLanguage.modelsFromDictionaryArray(array: dictionary["program_languages"] as! NSArray) }
        if (dictionary["transportations"] != nil) { transportations = Transportation.modelsFromDictionaryArray(array: dictionary["transportations"] as! NSArray) }
        if (dictionary["blood_types"] != nil) { blood_types = BloodType.modelsFromDictionaryArray(array: dictionary["blood_types"] as! NSArray) }
        if (dictionary["habit_ranks"] != nil) { habit_ranks = HabitRank.modelsFromDictionaryArray(array: dictionary["habit_ranks"] as! NSArray) }
        if (dictionary["diseases"] != nil) { diseases = Disease.modelsFromDictionaryArray(array: dictionary["diseases"] as! NSArray) }
        if (dictionary["character_types"] != nil) { character_types = CharacterType.modelsFromDictionaryArray(array: dictionary["character_types"] as! NSArray) }
        if (dictionary["bath_types"] != nil) { bath_types = BathType.modelsFromDictionaryArray(array: dictionary["bath_types"] as! NSArray) }
        if (dictionary["bath_potty_types"] != nil) { bath_potty_types = BathPottyType.modelsFromDictionaryArray(array: dictionary["bath_potty_types"] as! NSArray) }
	}
		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.status, forKey: "status")
        dictionary.setValue(self.config?.dictionaryRepresentation(), forKey: "config")
		dictionary.setValue(self.about?.dictionaryRepresentation(), forKey: "about")

		return dictionary
	}

}
