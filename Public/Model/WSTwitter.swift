//
//  WSTwitter.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/11.
//
//

import UIKit
import AVOSCloud

class WSTwitter: AVObject, AVSubclassing {
    
    @NSManaged var dtContent: String?
    @NSManaged var dtPictures: [String]?
    @NSManaged var dtAuthor: WSUser?
    @NSManaged var dtComments: [WSTwitter]?
    @NSManaged var dtLikes: [WSLike]?
    @NSManaged var atUser: WSUser?
    
    class func parseClassName() -> String! {
        return "WSTwitter"
    }
    
    override init() {
        super.init()
    }
}
