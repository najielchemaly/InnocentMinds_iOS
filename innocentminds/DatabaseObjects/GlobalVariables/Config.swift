/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Config {
	public var version_ios : String?
	public var version_android : String?
	public var version_outdate_message : String?
	public var base_url : String?
	public var media_url : String?
	public var is_review : String?
    public var now : String?

    public init() {}
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Config_list = Config.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Config Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Config]
    {
        var models:[Config] = []
        for item in array
        {
            models.append(Config(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Config = Config(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Config Instance.
*/
	required public init?(dictionary: NSDictionary) {

		version_ios = dictionary["version_ios"] as? String
		version_android = dictionary["version_android"] as? String
		version_outdate_message = dictionary["version_outdate_message"] as? String
		base_url = dictionary["base_url"] as? String
		media_url = dictionary["media_url"] as? String
		is_review = dictionary["is_review"] as? String
        now = dictionary["now"] as? String
	}
		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.version_ios, forKey: "version_ios")
		dictionary.setValue(self.version_android, forKey: "version_android")
		dictionary.setValue(self.version_outdate_message, forKey: "version_outdate_message")
		dictionary.setValue(self.base_url, forKey: "base_url")
		dictionary.setValue(self.media_url, forKey: "media_url")
		dictionary.setValue(self.is_review, forKey: "is_review")
        dictionary.setValue(self.now, forKey: "now")

		return dictionary
	}

}
