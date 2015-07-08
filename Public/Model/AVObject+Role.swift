//
//  AVObject+Role.swift
//  Crawler
//
//  Created by guangbo on 15/7/8.
//
//

import Foundation
import AVOSCloud

protocol RoleProtocal {
    static var ClassName_Role: String { get }
    
    static var RoleProperties: [String] { get }
    
    var roleName:String? {
        get set
    }
    var roleDesp:String? {
        get set
    }
    var roleGender:Int? {
        get set
    }
    var roleAvatars:[String]? {
        get set
    }
}

extension AVObject: RoleProtocal {
    
    static var ClassName_Role: String {
        return "Role"
    }
    
    static var RoleProperties: [String] {
        return ["roleName", "roleDesp", "roleGender", "roleAvatars"]
    }
    
    var roleName:String? {
        get {
            return self.objectForKey("roleName") as? String
        }
        set(newValue) {
            self.setObject(newValue, forKey: "roleName")
        }
    }
    
    var roleDesp:String? {
        get {
            return self.objectForKey("roleDesp") as? String
        }
        set(newValue) {
            self.setObject(newValue, forKey: "roleDesp")
        }
    }
    
    var roleGender:Int? {
        get {
            return self.objectForKey("roleGender") as? Int
        }
        set(newValue) {
            self.setObject(newValue, forKey: "roleGender")
        }
    }
    
    var roleAvatars:[String]? {
        get {
            return self.objectForKey("roleAvatars") as? [String]
        }
        set(newValue) {
            self.setObject(newValue, forKey: "roleAvatars")
        }
    }
}


