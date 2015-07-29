//
//  WSTwitterComment.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/18.
//
//

import UIKit
import AVOSCloud

class WSTwitterComment: AVObject, AVSubclassing {
    
    @NSManaged var content: String?
    
    static let WSTwitterCommentKey_author = "author"
    @NSManaged var author: AVUser?
    
    static let WSTwitterCommentKey_atUser = "atUser"
    @NSManaged var atUser: AVUser?
    
    static let WSTwitterCommentKey_twitter = "twitter"
    @NSManaged var twitter: WSTwitter?
    
    class func parseClassName() -> String! {
        return "WSTwitterComment"
    }
    
    override init() {
        super.init()
    }
}

extension WSTwitterComment {
    
    // 朋友圈动态的评论查询includeKeys
    static func PengYQTwitterCommentQueryIncludeKeys() -> [String] {
        return [WSTwitterCommentKey_author, WSTwitterCommentKey_atUser]
    }
}
