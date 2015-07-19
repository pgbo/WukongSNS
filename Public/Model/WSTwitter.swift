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
    
    @NSManaged var content: String?
    
    @NSManaged var pictures: [String]?
    
    static let WSTwitterKey_author = "author"
    @NSManaged var author: AVUser?
    
    static let WSTwitterKey_comments = "comments"
    @NSManaged var comments: [WSTwitterComment]?
    
    static let WSTwitterKey_likes = "likes"
    @NSManaged var likes: [AVUser]?
    
    static let WSTwitterKey_atUser = "atUser"
    @NSManaged var atUser: AVUser?
    
    class func parseClassName() -> String! {
        return "WSTwitter"
    }
    
    override init() {
        super.init()
    }
    
}

extension WSTwitter {
    
    // 朋友圈动态信息查询includeKeys
    static func PengYQTwitterQueryIncludeKeys() -> [String] {
        return [WSTwitterKey_author, WSTwitterKey_comments, WSTwitterKey_likes, WSTwitterKey_atUser]
    }
}
