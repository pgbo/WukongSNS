//
//  AVObjctKeyCheck.swift
//  PengYQ
//
//  Created by guangbo on 15/7/15.
//
//

import Foundation
import AVOSCloud

protocol AVOjectKeyCheck {
    
    /**
    *  注册class用以检测key
    */
    static func registerClassForCheckKeys()
}

class AVOjectKeyCheckSingeleton {
    
    lazy private var registerCassNames = [String]()
    
    static func shareInstance() -> AVOjectKeyCheckSingeleton {
        enum Static {
            static var once_token = 0
            static var instance: AVOjectKeyCheckSingeleton? = nil
        }
        dispatch_once(&Static.once_token) {
            Static.instance = AVOjectKeyCheckSingeleton()
        }
        return Static.instance!
    }
    
    func registerClassName(className: String) {
        if contains(registerCassNames, className) == false {
            registerCassNames.append(className)
        }
    }
    
    func checkIncludeKey(includeKey: String, forClass: AVObject) -> Bool {
        
        let properties = reflect(forClass)
        
        //因为是继承NSObject对象的，0是NSObject，所以从1开始
        for var i:Int = 1; i < properties.count; i++ {
            let property = properties[i]
            let key = property.0
            let type = property.1
            
            // 判断是否包含子key
            let keyLayers = includeKey.componentsSeparatedByString(".")
            if keyLayers.first == key {
                if keyLayers.count > 1 {
                    let secondLayerKey = keyLayers[1]
                    if type is Array<Int> {
                    
                    }
                    
                    for registerClassName in registerCassNames {
                        let clazz: AnyClass! = NSClassFromString(registerClassName)
                        if clazz is type {
                            
                        }
                    }
                    
                    
                    let secondLayerClassType: AnyClass?
                }
            }
            
            if includeKey == key {
                return true
            }
        }
        
        return false
        
    }
}