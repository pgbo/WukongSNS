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
    
    var roleName:String? {
        get set
    }
    var roleDesp:String? {
        get set
    }
    var roleAvatars:[String]? {
        get set
    }
}

let ClassRole = "ClassRole"
let FRoleName = "FRoleName"
let FRoleDesp = "FRoleDesp"
let FRoleAvatars = "FRoleAvatars"

extension AVObject: RoleProtocal {
    
    static var ClassName_Role: String {
        return ClassRole
    }
    
    var roleName:String? {
        get {
            return self.objectForKey(FRoleName) as? String
        }
        set(newValue) {
            self.setObject(newValue, forKey: FRoleName)
        }
    }
    
    var roleDesp:String? {
        get {
            return self.objectForKey(FRoleDesp) as? String
        }
        set(newValue) {
            self.setObject(newValue, forKey: FRoleDesp)
        }
    }
    
    var roleAvatars:[String]? {
        get {
            return self.objectForKey(FRoleAvatars) as? [String]
        }
        set(newValue) {
            self.setObject(newValue, forKey: FRoleAvatars)
        }
    }
}


