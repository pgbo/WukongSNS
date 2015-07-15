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
    
    let DTAUTHOR = "dtAuthor"
    @NSManaged var dtAuthor: WSUser?
    
    let DTCOMMENTS = "dtComments"
    @NSManaged var dtComments: [WSTwitter]?
    
    let DTLIKES = "dtLikes"
    @NSManaged var dtLikes: [WSLike]?
    
    let ATUSER = "atUser"
    @NSManaged var atUser: WSUser?
    
    class func parseClassName() -> String! {
        return "WSTwitter"
    }
    
    override init() {
        super.init()
    }
}
