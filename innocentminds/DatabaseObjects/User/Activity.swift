/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Activity: JSONable {
	public var id : String?
	public var type_id : String?
	public var child_id : String?
    public var title : String?
	public var description : String?
    public var rating : String?
    public var student_ids : String?
    public var from_date : String?
    public var to_date : String?
    public var time : String?
    public var bath_type_id : String?
    public var bath_potty_type_id : String?
	public var photos : Array<Photo>?
    
    public func getBathType() -> String? {
        guard let bathTypeId = bath_type_id else {
            return nil
        }
        
        guard let bathTypes = Objects.variables.bath_types else {
            return nil
        }
        
        let bathType = bathTypes.first { $0.id == bathTypeId }
        return bathType?.title
    }
    
    public func getBathPottyType() -> String? {
        guard let bathPottyTypeId = bath_potty_type_id else {
            return nil
        }
        
        guard let bathPottyTypes = Objects.variables.bath_potty_types else {
            return nil
        }
        
        let bathPottyType = bathPottyTypes.first { $0.id == bathPottyTypeId }
        return bathPottyType?.title
    }
    
    public init() {}
    
    public static let key: String = "Activity"
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let activities_list = Activity.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Activity Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Activity]
    {
        var models:[Activity] = []
        for item in array
        {
            models.append(Activity(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let activities = Activity(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Activity Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if let id = dictionary["id"] as? String {
            self.id = id
        } else if let id = dictionary["id"] as? Int {
            self.id = "\(id)"
        }
		type_id = dictionary["type_id"] as? String
		child_id = dictionary["child_id"] as? String
		rating = dictionary["rating"] as? String
		description = dictionary["description"] as? String
		title = dictionary["title"] as? String
        student_ids = dictionary["student_ids"] as? String
        from_date = dictionary["from_date"] as? String
        to_date = dictionary["to_date"] as? String
        time = dictionary["time"] as? String
        bath_type_id = dictionary["bath_type_id"] as? String
        bath_potty_type_id = dictionary["bath_potty_type_id"] as? String
        if let photosArray = dictionary["photos"] as? NSArray {
            photos = Photo.modelsFromDictionaryArray(array: photosArray)
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.type_id, forKey: "type_id")
		dictionary.setValue(self.child_id, forKey: "child_id")
		dictionary.setValue(self.rating, forKey: "rating")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.student_ids, forKey: "student_ids")
        dictionary.setValue(self.from_date, forKey: "from_date")
        dictionary.setValue(self.to_date, forKey: "to_date")
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.bath_type_id, forKey: "bath_type_id")
        dictionary.setValue(self.bath_potty_type_id, forKey: "bath_potty_type_id")
        dictionary.setValue(self.photos, forKey: "photos")

		return dictionary
	}
    
    public class func saveArray(activities: [Activity], key: String = Activity.key) {
        Cache.shared.setObject(activities as AnyObject, forKey: key as AnyObject)
    }
    
    public class func getArray(key: String) -> [Activity]? {
        guard let activities = Cache.shared.object(forKey: key as AnyObject) as? [Activity] else {
            return nil
        }
        
        return activities
    }
    
    public class func saveObject(activity: Activity, key: String = Activity.key) {
        let dictionary = activity.dictionaryRepresentation()
        Cache.shared.setObject(dictionary, forKey: key as AnyObject)
    }
    
    public class func getObject(key: String) -> Activity? {
        guard let dictionary = Cache.shared.object(forKey: key as AnyObject) as? NSDictionary else {
            return nil
        }
        
        return Activity(dictionary: dictionary)
    }

}
