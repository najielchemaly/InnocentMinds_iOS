/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class User {
	public var id : String?
	public var role_id : String?
	public var parent_type : String?
	public var fullname : String?
	public var phone : String?
	public var email : String?
	public var address : String?
	public var mobile : String?
	public var now : String?
    public var hear_about_us : String?
	public var classes : Array<Class>?
	public var children : Array<Child>?

    public static let key: String = "User"
    
    public init() {}
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let user_list = User.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of User Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let user = User(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		role_id = dictionary["role_id"] as? String
		parent_type = dictionary["parent_type"] as? String
		fullname = dictionary["fullname"] as? String
		phone = dictionary["phone"] as? String
		email = dictionary["email"] as? String
		address = dictionary["address"] as? String
		mobile = dictionary["mobile"] as? String
		now = dictionary["now"] as? String
        hear_about_us = dictionary["hear_about_us"] as? String
        if (dictionary["classes"] != nil) { classes = Class.modelsFromDictionaryArray(array: dictionary["classes"] as! NSArray) }
		if (dictionary["children"] != nil) { children = Child.modelsFromDictionaryArray(array: dictionary["children"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.role_id, forKey: "role_id")
		dictionary.setValue(self.parent_type, forKey: "parent_type")
		dictionary.setValue(self.fullname, forKey: "fullname")
		dictionary.setValue(self.phone, forKey: "phone")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.mobile, forKey: "mobile")
		dictionary.setValue(self.now, forKey: "now")
        dictionary.setValue(self.hear_about_us, forKey: "hear_about_us")
        dictionary.setValue(self.classes, forKey: "classes")
        dictionary.setValue(self.children, forKey: "children")

		return dictionary
	}
    
    public class func saveObject(user: User, key: String = User.key) {
        let dictionary = user.dictionaryRepresentation()
        Cache.shared.setObject(dictionary, forKey: key as AnyObject)
    }
    
    public class func getObject(key: String) -> User? {
        guard let dictionary = Cache.shared.object(forKey: key as AnyObject) as? NSDictionary else {
            return nil
        }
        
        return User(dictionary: dictionary)
    }

}
