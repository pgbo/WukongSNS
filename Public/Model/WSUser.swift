//
//  WSUser.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/11.
//
//

import UIKit
import AVOSCloud

class WSUser: AVUser, AVSubclassing {

    @NSManaged var userGender:Int
    @NSManaged var userAge:Int
    @NSManaged var userCurrentRole:WSRole?
    @NSManaged var userBackgroudImages:[String]?
    
    static func parseClassName() -> String! {
        return "_User"
    }
    
    override init() {
        super.init()
    }
    
    override init(className newClassName: String!) {
        super.init(className: newClassName)
    }
}
