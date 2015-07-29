//
//  LocalRole.swift
//  Crawler
//
//  Created by guangbo on 15/7/7.
//
//

import Foundation
import CoreData

class LocalRole: NSManagedObject {

    @NSManaged var name: String?
    @NSManaged var desp: String?
    @NSManaged var gender: NSNumber?
    @NSManaged var avatarUrls: AnyObject?

}
