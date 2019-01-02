//
//  Objects.swift
//  innocentminds
//
//  Created by MR.CHEMALY on 10/9/18.
//  Copyright © 2018 infosys. All rights reserved.
//

import Foundation

struct Objects {
    static var user: User = User()
    static var variables: Variables = Variables()
    static var payments: [Payment] = [Payment]()
    
    static let answers: [String] = [
        "Yes",
        "No"
    ]
}

class Cache: NSCache<AnyObject, AnyObject> {
    static let shared = NSCache<AnyObject, AnyObject>()
    
    private override init() {
        super.init()
    }
}
