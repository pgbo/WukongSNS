//
//  WSLike.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/12.
//
//

import UIKit
import AVOSCloud

class WSLike: AVObject, AVSubclassing {
    
    @NSManaged var lAuthor: WSUser?
    
    static func parseClassName() -> String! {
        return "WSLike"
    }
    
    override init() {
        super.init()
    }
}
