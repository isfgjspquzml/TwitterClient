//
//  User.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/27/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var username: String?
    var location: String?
    var profileImageUrl: String?
    var tagLine: String?
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
        self.username = dictionary["screen_name"] as? String
        self.location = dictionary["location"] as? String
        self.profileImageUrl = dictionary["profile_image_url"] as? String ?? ""
        self.tagLine = dictionary["description"] as? String ?? ""
    }
}
