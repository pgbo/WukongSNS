//
//  WKUser.swift
//  WukongSNS
//
//  Created by guangbo on 15/7/3.
//
//

import UIKit

/**
*  用户信息
*/
class WKUser: AVUser {
    var nickname:String?
    var gender:Gender?
    var age:Int?
    var historyRoles:[UserRole]?
    var currentRole:UserRole?
    var avatars:[ImageInfo]?
    var backgroudImages:[ImageInfo]?
}
