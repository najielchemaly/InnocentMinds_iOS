/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Payment {
	public var child_id : String?
	public var amount : String?
	public var date : String?
	public var description : String?
	public var type_id : String?
    public var invoice_number : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Payment_list = Payment.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Payment Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Payment]
    {
        var models:[Payment] = []
        for item in array
        {
            models.append(Payment(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Payment = Payment(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Payment Instance.
*/
	required public init?(dictionary: NSDictionary) {

		child_id = dictionary["child_id"] as? String
		amount = dictionary["amount"] as? String
		date = dictionary["date"] as? String
		description = dictionary["description"] as? String
		type_id = dictionary["type_id"] as? String
        invoice_number = dictionary["invoice_number"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.child_id, forKey: "child_id")
		dictionary.setValue(self.amount, forKey: "amount")
		dictionary.setValue(self.date, forKey: "date")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.type_id, forKey: "type_id")
        dictionary.setValue(self.invoice_number, forKey: "invoice_number")

		return dictionary
	}

}
