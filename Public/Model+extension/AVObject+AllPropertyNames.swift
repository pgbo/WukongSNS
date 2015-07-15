//
//  AVObject+AllPropertyNames.swift
//  PengYQ
//
//  Created by guangbo on 15/7/15.
//
//

import Foundation
import AVOSCloud

extension AVObject {
    func allPropertyNames()->[String]
    {
        let m = reflect(self)
        var s = [String]()
        for i in 0..<m.count
        {
            let (name,_)  = m[i]
            if name == "super"{continue}
            s.append(name)
        }
        return s
    }
}