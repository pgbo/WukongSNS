//
//  AVObject+WKUser.swift
//  Crawler
//
//  Created by guangbo on 15/7/8.
//
//

import Foundation
import AVOSCloud

protocol WKUserProtocol {
    static var ClassName_WKUser: String { get }
    var userNickname:String? { get set }
    var userGender:Int? { get set }
    var userAge:Int? { get set }
    var userHistoryRoles:[AVObject]? { get set }
    var userCurrentRole:AVObject? { get set }
    var userAvatars:[String]? { get set }
    var userBackgroudImages:[String]? { get set }
}

extension AVObject: WKUserProtocol {
    static var ClassName_WKUser: String {
        return "WKUser"
    }
    
    var userNickname:String? {
        get {
            return self.objectForKey("userNickname") as? String
        }
        set(newNickname) {
            self.setObject(newNickname, forKey: "userNickname")
        }
    }
    
    var userGender:Int? {
        get {
            return self.objectForKey("userGender") as? Int
        }
        set(newGender) {
            self.setObject(newGender, forKey: "userGender")
        }
    }
    
    var userAge:Int? {
        get {
            return self.objectForKey("userAge") as? Int
        }
        set(newAge) {
            self.setObject(newAge, forKey: "userAge")
        }
    }
    
    var userHistoryRoles:[AVObject]? {
        get {
            return self.objectForKey("userHistoryRoles") as? [AVObject]
        }
        set(newHistoryRoles) {
            self.setObject(newHistoryRoles, forKey: "userHistoryRoles")
        }
    }
    
    var userCurrentRole:AVObject? {
        get {
            return self.objectForKey("userCurrentRole") as? AVObject
        }
        set(newCurrentRole) {
            self.setObject(newCurrentRole, forKey: "userCurrentRole")
        }
    }
    
    var userAvatars:[String]? {
        get {
            return self.objectForKey("userAvatars") as? [String]
        }
        set(newAvatars) {
            self.setObject(newAvatars, forKey: "userAvatars")
        }
    }
    
    var userBackgroudImages:[String]? {
        get {
            return self.objectForKey("userBackgroudImages") as? [String]
        }
        set(newBackgroudImages) {
            self.setObject(newBackgroudImages, forKey: "userBackgroudImages")
        }
    }
}