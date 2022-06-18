/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class SendActivity: JSONable {
    public var child_id : Int?
    public var user_id : Int?
    public var child_activities : Array<Activity>?

    public init() {}
    
    public init(user_id: Int, child_id: Int, child_activities: [Activity]) {
        self.user_id = user_id
        self.child_id = child_id
        self.child_activities = child_activities
    }
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let SendActivityes_list = SendActivity.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of SendActivity Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [SendActivity]
    {
        var models:[SendActivity] = []
        for item in array
        {
            models.append(SendActivity(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let SendActivityes = SendActivity(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: SendActivity Instance.
*/
	required public init?(dictionary: NSDictionary) {

        child_id = dictionary["child_id"] as? Int
        user_id = dictionary["user_id"] as? Int
        if let activitiesArray = dictionary["child_activities"] as? NSArray {
            child_activities = Activity.modelsFromDictionaryArray(array: activitiesArray)
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()
        dictionary.setValue(self.child_id, forKey: "child_id")
        dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.child_activities, forKey: "child_activities")

		return dictionary
	}

}
