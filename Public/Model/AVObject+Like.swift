//
//  AVObject+Like.swift
//  Crawler
//
//  Created by guangbo on 15/7/8.
//
//

import Foundation
import AVOSCloud

protocol LikeProtocol {
    static var ClassName_Like: String { get }
    
    /// 点赞用户
    var likeActUser: AVObject? { get set }
}

extension AVObject: LikeProtocol {
    static var ClassName_Like: String {
        return "Like"
    }
    
    /// 点赞用户
    var likeActUser: AVObject? {
        get {
            return self.objectForKey("likeActUser") as? AVObject
        }
        set(newAuthor) {
            self.setObject(newAuthor, forKey: "likeActUser")
        }
    }
}
