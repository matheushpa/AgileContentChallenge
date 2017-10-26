//
//  Profile.swift
//  AgileContentChallenge
//
//  Created by Matheus Holanda on 24/10/17.
//  Copyright © 2017 NATI. All rights reserved.
//

import UIKit
import ObjectMapper

class Repository: Mappable {
    
    dynamic var name = ""
    dynamic var language = ""
    
    required convenience init?(map: Map) {
        
        self.init()
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
        language <- map["language"]
    }
}

class User: Mappable {
    
    var name = ""
    var username = ""
    var avatarImage = ""
    
    required convenience init?(map: Map) {
        
        self.init()
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
        username <- map["login"]
        avatarImage <- map["avatar_url"]
    }
}
