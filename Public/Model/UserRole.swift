//
//  UserRole.swift
//  WukongSNS
//
//  Created by guangbo on 15/7/3.
//
//

import UIKit
import AVOSCloud

enum Gender {
    case Male
    case Female
}

/**
*  人物角色
*/
class UserRole: AVObject {
    var name:String?
    var desp:String?
    var gender:Gender?
    var avatars:[ImageInfo]?
}
