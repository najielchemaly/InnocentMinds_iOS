/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Contact {
	public var branch_id : String?
	public var location : String?
	public var email : String?
    public var phone : String?
    public var phone_numbers : Array<PhoneNumber>?

    public init() {}
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let contact_list = Contact.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Contact Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Contact]
    {
        var models:[Contact] = []
        for item in array
        {
            models.append(Contact(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let contact = Contact(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Contact Instance.
*/
	required public init?(dictionary: NSDictionary) {

		branch_id = dictionary["branch_id"] as? String
		location = dictionary["location"] as? String
		email = dictionary["email"] as? String
        phone = dictionary["phone"] as? String
        if (dictionary["phone_numbers"] != nil) {
            phone_numbers = PhoneNumber.modelsFromDictionaryArray(array: dictionary["phone_numbers"] as! NSArray)
        } else if let numberArray = phone?.split(separator: ",") {
            phone_numbers = Array<PhoneNumber>()
            for number in numberArray {
                phone_numbers?.append(PhoneNumber(text: "\(number)"))
            }
        }
	}
		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.branch_id, forKey: "branch_id")
		dictionary.setValue(self.location, forKey: "location")
		dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.phone, forKey: "phone")
        dictionary.setValue(self.phone_numbers, forKey: "phone_numbers")

		return dictionary
	}

}
