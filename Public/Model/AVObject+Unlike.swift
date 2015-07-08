//
//  AVObject+Unlike.swift
//  Crawler
//
//  Created by guangbo on 15/7/8.
//
//

import Foundation
import AVOSCloud

protocol UnlikeProtocol {
    static var ClassName_Unlike: String { get }
    
    /// 点down用户
    var unlikeActUser: AVObject? { get set }
}

extension AVObject: UnlikeProtocol {
    static var ClassName_Unlike: String {
        return "Uklike"
    }
    
    /// 点down用户
    var unlikeActUser: AVObject? {
        get {
            return self.objectForKey("unlikeActUser") as? AVObject
        }
        set(newAuthor) {
            self.setObject(newAuthor, forKey: "unlikeActUser")
        }
    }
}