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
    var groupName:String? { get set }
    var groupDesp:String? { get set }
}

extension AVObject: RoleGroupProtocol {
    static var ClassName_RoleGroup: String {
        return "RoleGroup"
    }
    
    var groupName:String? {
        get {
            return self.objectForKey("groupName") as? String
        }
        set(newGroupName) {
            self.setObject(newGroupName, forKey: "groupName")
        }
    }
    
    var groupDesp:String? {
        get {
            return self.objectForKey("groupDesp") as? String
        }
        set(newGroupDesp) {
            self.setObject(newGroupDesp, forKey: "groupDesp")
        }
    }
}