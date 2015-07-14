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
    
    let DTCONETNT = "dtContent"
    @NSManaged var dtContent: String?
    let DTPICTURES = "dtPictures"
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
