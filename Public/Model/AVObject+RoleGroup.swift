//
//  AVObject+RoleGroup.swift
//  Crawler
//
//  Created by guangbo on 15/7/8.
//
//

import Foundation
import AVOSCloud

protocol RoleGroupProtocol {
    static var ClassName_RoleGroup: String { get }
    var roleGroupName:String? { get set }
    var roleGroupDesp:String? { get set }
}

let ClassRoleGroup = "ClassRoleGroup"
let FRoleGroupName = "FRoleName"
let FRoleGroupDesp = "FRoleDesp"

extension AVObject: RoleGroupProtocol {
    static var ClassName_RoleGroup: String {
        return ClassRoleGroup
    }
    
    var roleGroupName:String? {
        get {
            return self.objectForKey(FRoleGroupName) as? String
        }
        set(newGroupName) {
            self.setObject(newGroupName, forKey: FRoleGroupName)
        }
    }
    
    var roleGroupDesp:String? {
        get {
            return self.objectForKey(FRoleGroupDesp) as? String
        }
        set(newGroupDesp) {
            self.setObject(newGroupDesp, forKey: FRoleGroupDesp)
        }
    }
}