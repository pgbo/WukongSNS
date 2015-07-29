//
//  WSRole.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/11.
//
//

import UIKit
import AVOSCloud

class WSRole: AVObject, AVSubclassing {
   
    @NSManaged var FRoleName:String?
    @NSManaged var FRoleDesp:String?
    @NSManaged var FRoleAvatars:[String]?
    
    class func parseClassName() -> String! {
        return "ClassRole"
    }
    
    override init() {
        super.init()
    }
}
