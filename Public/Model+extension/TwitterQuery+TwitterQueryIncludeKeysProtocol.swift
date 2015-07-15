//
//  WSTwitter+query.swift
//  PengYQ
//
//  Created by guangbo on 15/7/15.
//
//

import Foundation

extension WSTwitter: TwitterQueryIncludeKeysProtocol {
    
    func twitterQueryIncludeKeys() -> [String]? {
        let includeKeys = allPropertyNames()
        println("includeKeys:\(includeKeys)")
        
        for queryKey in includeKeys {
            if (queryKey == "dtComments") {
                
            } else {
                
                // 根据key获取值类型
            }
        }
        return includeKeys
    }
    
    func joinKeys() -> [String] {
        return [""]
    }
}

extension WSUser: TwitterQueryIncludeKeysProtocol {
    
    func twitterQueryIncludeKeys() -> [String]? {
        return ["FRoleName", "FRoleDesp", "FRoleAvatars"]
    }
}
