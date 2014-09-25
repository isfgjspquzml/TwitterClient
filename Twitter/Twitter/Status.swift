//
//  Status.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/24/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class Status: NSObject {
    var text: NSString
    init(dictionary: NSDictionary) {
            self.text = dictionary["text"] as NSString
    }
}
