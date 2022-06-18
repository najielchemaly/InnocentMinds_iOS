/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import UIKit
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Event: JSONable {
	public var id : String?
	public var title : String?
	public var date : String?
    public var time : String?
	public var description : String?
    public var image : Data?
    
    public init() {}
    
    public static let key: String = "Event"
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let activities_list = Event.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Event Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Event]
    {
        var models:[Event] = []
        for item in array
        {
            models.append(Event(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let activities = Event(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Event Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if let id = dictionary["id"] as? String {
            self.id = id
        } else if let id = dictionary["id"] as? Int {
            self.id = "\(id)"
        }
		title = dictionary["title"] as? String
		date = dictionary["date"] as? String
		time = dictionary["time"] as? String
		description = dictionary["description"] as? String
        if let base64 = dictionary["image"] as? String {
            if let dataDecoded : Data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) {
                self.image = dataDecoded
            }
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.date, forKey: "date")
		dictionary.setValue(self.time, forKey: "time")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.image, forKey: "image")

		return dictionary
	}
    
    public class func saveArray(activities: [Event], key: String = Event.key) {
        Cache.shared.setObject(activities as AnyObject, forKey: key as AnyObject)
    }
    
    public class func getArray(key: String) -> [Event]? {
        guard let activities = Cache.shared.object(forKey: key as AnyObject) as? [Event] else {
            return nil
        }
        
        return activities
    }
    
    public class func saveObject(Event: Event, key: String = Event.key) {
        let dictionary = Event.dictionaryRepresentation()
        Cache.shared.setObject(dictionary, forKey: key as AnyObject)
    }
    
    public class func getObject(key: String) -> Event? {
        guard let dictionary = Cache.shared.object(forKey: key as AnyObject) as? NSDictionary else {
            return nil
        }
        
        return Event(dictionary: dictionary)
    }

}
