//
//  AVObject+DongTai.swift
//  Crawler
//
//  Created by guangbo on 15/7/8.
//
//

import Foundation
import AVOSCloud

protocol DongTaiProtocol {
    static var ClassName_DongTai: String { get }
    var dtContent: String? { get set }
    var dtPictures: [String]? { get set }
    var dtAuthor: AVObject? { get set }
    var dtComments: [AVObject]? { get set }
    var dtParent: AVObject? { get set }
    var dtLikes: [AVObject]? { get set }
    var dtUnlikes: [AVObject]? { get set }
}

extension AVObject:DongTaiProtocol {
    
    static var ClassName_DongTai: String {
        return "DongTai"
    }
    
    var dtContent: String? {
        get {
            return self.objectForKey("dtContent") as? String
        }
        set (newContent) {
            self.setObject(newContent, forKey: "dtContent")
        }
    }
    
    var dtPictures: [String]? {
        get {
            return self.objectForKey("dtPictures") as? [String]
        }
        set (newPicttures) {
            self.setObject(newPicttures, forKey: "dtPictures")
        }
    }
    
    var dtAuthor: AVObject? {
        get {
            return self.objectForKey("dtAuthor") as? AVObject
        }
        set (newAuthor) {
            self.setObject(newAuthor, forKey: "dtAuthor")
        }
    }

    var dtComments: [AVObject]? {
        get {
            return self.objectForKey("dtComments") as? [AVObject]
        }
        set (newComments)  {
            self.setObject(newComments, forKey: "dtComments")
        }
    }
    
    var dtParent: AVObject? {
        get {
            return self.objectForKey("dtParent") as? AVObject
        }
        set (newParent) {
            self.setObject(newParent, forKey: "dtParent")
        }
    }
    
    var dtLikes: [AVObject]? {
        get {
            return self.objectForKey("dtLikes") as? [AVObject]
        }
        set (newContent) {
            self.setObject(newContent, forKey: "dtLikes")
        }
    }
    
    var dtUnlikes: [AVObject]? {
        get {
            return self.objectForKey("dtUnlikes") as? [AVObject]
        }
        set (newContent) {
            self.setObject(newContent, forKey: "dtUnlikes")
        }
    }
}
