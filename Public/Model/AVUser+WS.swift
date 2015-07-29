//
//  WAVUser+WS.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/11.
//
//

import UIKit
import AVOSCloud

extension AVUser {

    private static let userRoleObjectIdKey = "userRoleObjectId"
    func getUserRoleObjectId() -> String? {
        return objectForKey(AVUser.userRoleObjectIdKey) as? String
    }
    
    func setUserRoleObjectId(newValue: String?) {
        if newValue == nil {
            removeObjectForKey(AVUser.userRoleObjectIdKey)
        } else {
            setObject(newValue, forKey: AVUser.userRoleObjectIdKey)
        }
    }
    
    private static let userRoleNameKey = "userRoleName"
    func getUserRoleName() -> String? {
        return objectForKey(AVUser.userRoleNameKey) as? String
    }
    
    func setUserRoleName(newValue: String?) {
        if newValue == nil {
            removeObjectForKey(AVUser.userRoleNameKey)
        } else {
            setObject(newValue, forKey: AVUser.userRoleNameKey)
        }
    }
    
    private static let userRoleDespKey = "userRoleDesp"
    func getUserRoleDesp() -> String? {
        return objectForKey(AVUser.userRoleDespKey) as? String
    }
    
    func setUserRoleDesp(newValue: String?) {
        if newValue == nil {
            removeObjectForKey(AVUser.userRoleDespKey)
        } else {
            setObject(newValue, forKey: AVUser.userRoleDespKey)
        }
    }
    
    private static let userRoleAvatarsKey = "userRoleAvatars"
    func getUserRoleAvatars() -> [String]? {
        return objectForKey(AVUser.userRoleAvatarsKey) as? [String]
    }
    
    func setUserRoleAvatars(newValue: [String]?) {
        if newValue == nil {
            removeObjectForKey(AVUser.userRoleAvatarsKey)
        } else {
            setObject(newValue, forKey: AVUser.userRoleAvatarsKey)
        }
    }
}
