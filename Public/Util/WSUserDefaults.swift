//
//  WSUserDefaults.swift
//  PengYQ
//
//  Created by guangbo on 15/7/9.
//
//

import Foundation
import AVOSCloud

// 上次登录用户的key
//let UD_kLastLoginUserObjectID = "UD_kLastLoginUserObjectID"
//let UD_kLastLoginUserPlayedRoleName = "UD_kLastLoginUserPlayedRoleName"
//let UD_kLastLoginUserPlayedRoleDesp = "UD_kLastLoginUserPlayedRoleDesp"
//let UD_kLastLoginUserPlayedRoleAvatars = "UD_kLastLoginUserPlayedRoleAvatars"
//let UD_kLastLoginUserBackgroundImages = "UD_kLastLoginUserBackgroundImages"
//
//class WSUserDefaults {
//    
//    /**
//    是否正在扮演角色
//    
//    :returns:
//    */
//    static func isPlayingRole() -> Bool {
//        if NSUserDefaults.standardUserDefaults().stringForKey(UD_kLastLoginUserObjectID) != nil {
//            return true
//        }
//        return false
//    }
//    
//    static func loginUser() -> AVUser? {
//        if isPlayingRole() {
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//            let loginUser = AVUser(className: AVUser.ClassName_WKUser)
//            loginUser.objectId = userDefaults.stringForKey(UD_kLastLoginUserObjectID)
//            
//            let userCurrentRole = AVObject(className: AVObject.ClassName_Role)
//            userCurrentRole.roleName = userDefaults.stringForKey(UD_kLastLoginUserPlayedRoleName)
//            userCurrentRole.roleDesp = userDefaults.stringForKey(UD_kLastLoginUserPlayedRoleDesp)
//            userCurrentRole.roleAvatars = userDefaults.arrayForKey(UD_kLastLoginUserPlayedRoleAvatars) as? [String]
//            
//            loginUser.userCurrentRole = userCurrentRole
//            
//            loginUser.userBackgroudImages = userDefaults.arrayForKey(UD_kLastLoginUserBackgroundImages) as? [String]
//            
//            return loginUser
//        }
//        return nil
//    }
//}