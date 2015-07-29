//
//  WSRoleGroup.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/11.
//
//

import UIKit
import AVOSCloud

class WSRoleGroup: AVObject, AVSubclassing {
    
    @NSManaged var FRoleGroupName:String?
    @NSManaged var FRoleGroupDesp:String?
    
    static func parseClassName() -> String! {
        return "ClassRoleGroup"
    }
    
    override init() {
        super.init()
    }
}
