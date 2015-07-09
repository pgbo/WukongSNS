//
//  ViewController.swift
//  Crawler
//
//  Created by 彭光波 on 15/7/6.
//
//

import UIKit
import Haneke
import SVProgressHUD
import AVOSCloud
import Alamofire
import CoreData

let RoleGroupClassName = "RoleGroup"
let RoleClassName = "Role"
let CrawlMRPYQ_AccessToken = "559651eefbe78e46c231a25e.1466673135.1eec9af45c823eade1100de3aa948d3f"

class ViewController: UIViewController {

    @IBOutlet private weak var originRoleGroupCountLabel:UILabel?
    @IBOutlet private weak var originRoleCountLabel:UILabel?
    
    @IBOutlet private weak var localRoleGroupCountLabel:UILabel?
    @IBOutlet private weak var localRoleCountLabel:UILabel?
    
    @IBOutlet private weak var clearLocalDataButton:UIButton?
    @IBOutlet private weak var startCrawlerButton:UIButton?
    @IBOutlet private weak var uploadDataButton:UIButton?
    
    private var crawlRoleGroupDataGroup:dispatch_group_t? = dispatch_group_create()
    private var crawlRoleDataGroup:dispatch_group_t? = dispatch_group_create()
    private var crawlRoleGroupNumber = 0
    private var crawlRoleNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearLocalDataButton?.addTarget(self, action:"clearLocalData", forControlEvents: UIControlEvents.TouchUpInside)
        
        startCrawlerButton?.addTarget(self, action:"startCrawl", forControlEvents: UIControlEvents.TouchUpInside)
        
        uploadDataButton?.addTarget(self, action:"uploadData", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let managedObjCtx = AppDelegate.instanse().managedObjectContext
        
        // 获取本地数据
        let localRoleGroupDescription =
        NSEntityDescription.entityForName("LocalRoleGroup",
            inManagedObjectContext: managedObjCtx!)
        
        let groupRequest = NSFetchRequest()
        groupRequest.entity = localRoleGroupDescription
        groupRequest.resultType = NSFetchRequestResultType.CountResultType
        var error: NSError?
        let groupCount = managedObjCtx?.countForFetchRequest(groupRequest, error: &error)
        localRoleGroupCountLabel?.text = "\(groupCount)"
        
        let localRoleDescription =
        NSEntityDescription.entityForName("LocalRole",
            inManagedObjectContext: managedObjCtx!)
        
        let roleRequest = NSFetchRequest()
        roleRequest.entity = localRoleDescription
        roleRequest.resultType = NSFetchRequestResultType.CountResultType
        let roleCount = managedObjCtx?.countForFetchRequest(roleRequest, error: &error)
        localRoleCountLabel?.text = "\(roleCount)"
        
        // 获取原数据
        SVProgressHUD.showWithStatus("获取原数据中...", maskType: SVProgressHUDMaskType.Black)

        let groupCountQuery = AVQuery(className: RoleGroupClassName)
        groupCountQuery.countObjectsInBackgroundWithBlock { [weak self] (groupCount:Int, error:NSError!) -> Void in
            if let strongSelf = self {
                println("groupCount:\(groupCount), error:\(error?.description)")
                dispatch_async(dispatch_get_main_queue()){
                    strongSelf.originRoleGroupCountLabel?.text = String("\(groupCount)")
                }
                let roleCountQuery = AVQuery(className: RoleClassName)
                roleCountQuery.countObjectsInBackgroundWithBlock({ [weak strongSelf] (roleCount:Int, error:NSError!) -> Void in
                    if let inStrongSelf = strongSelf {
                        println("roleCount:\(roleCount), error:\(error?.localizedFailureReason)")
                        dispatch_async(dispatch_get_main_queue()){
                            inStrongSelf.originRoleCountLabel?.text = String("\(roleCount)")
                            if error != nil {
                                SVProgressHUD.showErrorWithStatus(error.localizedFailureReason)
                            } else {
                                SVProgressHUD.showSuccessWithStatus("已经存在\(groupCount)个角色组, \(roleCount)个角色")
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    internal func clearLocalData() {
        let managedObjCtx = AppDelegate.instanse().managedObjectContext
        
        // 获取本地数据
        let localRoleGroupDescription =
        NSEntityDescription.entityForName("LocalRoleGroup",
            inManagedObjectContext: managedObjCtx!)
        
        let groupRequest = NSFetchRequest()
        groupRequest.entity = localRoleGroupDescription
        var error: NSError?
        let groupResults = managedObjCtx?.executeFetchRequest(groupRequest, error: &error) as! [NSManagedObject]
        if groupResults.count > 0 {
            for obj in groupResults {
                managedObjCtx?.deleteObject(obj)
            }
        }
        localRoleGroupCountLabel?.text = "\(0)"
        
        let localRoleDescription =
        NSEntityDescription.entityForName("LocalRole",
            inManagedObjectContext: managedObjCtx!)
        
        let roleRequest = NSFetchRequest()
        roleRequest.entity = localRoleDescription
        let roleResults = managedObjCtx?.executeFetchRequest(roleRequest, error: &error) as! [NSManagedObject]
        if roleResults.count > 0 {
            for obj in groupResults {
                managedObjCtx?.deleteObject(obj)
            }
        }
        localRoleCountLabel?.text = "\(0)"
    }

    internal func startCrawl() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)){ [weak self] () -> Void in
            
            if let ExtStrongSelf = self {
                dispatch_group_enter(ExtStrongSelf.crawlRoleGroupDataGroup!)
                
                // 爬取群组
                dispatch_async(dispatch_get_main_queue()){
                    SVProgressHUD.showWithStatus("爬取群组...", maskType: SVProgressHUDMaskType.Black)
                }
                
                Alamofire.request(.GET, "http://api.mrpyq.com/user/user_groups?access_token=\(CrawlMRPYQ_AccessToken)").responseJSON(options: NSJSONReadingOptions()) { [weak self] (request, response, dictionary, error) -> Void in
                    if let strongSelf = self {
                        if let jsonObj = dictionary as? [String:AnyObject] {
                            let items = jsonObj["items"] as! [[String:AnyObject]]
                            for itemObj in items {
                                // 保存群组到本地
                                let newlocalGroup = NSEntityDescription.insertNewObjectForEntityForName("LocalRoleGroup", inManagedObjectContext: AppDelegate.instanse().managedObjectContext!) as! LocalRoleGroup
                                
                                newlocalGroup.name = (itemObj["name"] as? String)!
                                println("保存角色组到数据库:\(newlocalGroup)")
                            }
                            strongSelf.crawlRoleGroupNumber = items.count
                        } else {
                            strongSelf.crawlRoleGroupNumber = 0
                        }
                        dispatch_group_leave(strongSelf.crawlRoleGroupDataGroup!)
                    }
                }
                dispatch_group_wait(ExtStrongSelf.crawlRoleGroupDataGroup!, DISPATCH_TIME_FOREVER)
                
                
                // 爬取角色
                dispatch_async(dispatch_get_main_queue()){
                    SVProgressHUD.setStatus("爬取角色...")
                }
                
                var hasMore = true
                var crawlIndex = 1
                var crawlRoleCount = 0
                while hasMore {
                    
                    dispatch_group_enter(ExtStrongSelf.crawlRoleDataGroup!)
                    
                    Alamofire.request(.GET, "http://api.mrpyq.com/user/users?access_token=\(CrawlMRPYQ_AccessToken)&page=\(crawlIndex)").responseJSON(options: NSJSONReadingOptions(), completionHandler: { [weak self] (request, response, dictionary, error) -> Void in
                        if let strongSelf = self {
                            if let jsonObj = dictionary as? [String:AnyObject] {
                                
                                let items = jsonObj["items"] as! [[String:AnyObject]]
                                for itemObj in items {
                                    
                                    // 保存到本地
                                    let newlocalRole = NSEntityDescription.insertNewObjectForEntityForName("LocalRole", inManagedObjectContext: AppDelegate.instanse().managedObjectContext!) as! LocalRole
                                    
                                    newlocalRole.name = (itemObj["name"] as? String)!
                                    newlocalRole.desp = (itemObj["description"] as? String)!
                                    if let avatars = itemObj["avatars"] as? [[String:AnyObject]] {
                                        var avatarUrls:[String] = []
                                        for avatarObj in avatars {
                                            avatarUrls.append(avatarObj["headimg"] as! String)
                                        }
                                        newlocalRole.avatarUrls = avatarUrls
                                    }
                                    
                                    println("保存角色到数据库:\(newlocalRole)")
                                }
                                
                                hasMore = jsonObj["pagemore"] as! Bool
                                crawlRoleCount += jsonObj["count"] as! Int
                                
                            } else {
                                hasMore = false
                            }
                            
                            crawlIndex += 1
                            dispatch_group_leave(strongSelf.crawlRoleDataGroup!)
                        }
                        })
                    dispatch_group_wait(ExtStrongSelf.crawlRoleDataGroup!, DISPATCH_TIME_FOREVER)
                }
                
                ExtStrongSelf.crawlRoleNumber = crawlRoleCount
                
                dispatch_async(dispatch_get_main_queue()){
                    SVProgressHUD.showSuccessWithStatus("抓取的角色群组数量:\(ExtStrongSelf.crawlRoleGroupNumber), 抓取的角色数量:\(ExtStrongSelf.crawlRoleNumber)")
                }
            }
        }
    }
    
    internal func uploadData() {
        
        // 获取本地数据然后上传到服务端，上传成功后删除
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)){ [weak self] () -> Void in
         
            if let strongSelf = self {
        
                // 上传群组数据
                dispatch_async(dispatch_get_main_queue()){
                    SVProgressHUD.showWithStatus("上传群组数据...", maskType: SVProgressHUDMaskType.Black)
                }
                
                let managedObjCtx = AppDelegate.instanse().managedObjectContext
                
                let localRoleGroupDescription =
                NSEntityDescription.entityForName("LocalRoleGroup",
                    inManagedObjectContext: managedObjCtx!)
                
                let groupRequest = NSFetchRequest()
                groupRequest.entity = localRoleGroupDescription
                var error: NSError?
                let groupResults = managedObjCtx?.executeFetchRequest(groupRequest, error: &error) as! [LocalRoleGroup]
                
                // 最后删除
                if groupResults.count > 0 {
                    for obj in groupResults {
                        
                        var newGroup = AVObject(className: AVObject.ClassName_RoleGroup)
                        newGroup.roleGroupName = obj.name
                        if let groupDesp = obj.groupDesp {
                            newGroup.roleGroupDesp = groupDesp
                        }
                        
                        if newGroup.save(&error) {
                            managedObjCtx?.deleteObject(obj)
                        }
                    }
                }
                
                
                // 上传角色数据
                dispatch_async(dispatch_get_main_queue()){
                    SVProgressHUD.setStatus("上传角色数据...")
                }
                
                let localRoleDescription =
                NSEntityDescription.entityForName("LocalRole",
                    inManagedObjectContext: managedObjCtx!)
                
                var fetchOffset = 0
                var hasMore = true
                
                while hasMore {
                    
                    let roleRequest = NSFetchRequest()
                    
                    roleRequest.fetchLimit = 500
                    roleRequest.fetchOffset = fetchOffset
                    roleRequest.entity = localRoleDescription
                    let roleResults = managedObjCtx?.executeFetchRequest(roleRequest, error: &error) as! [LocalRole]
                    
                    let resultCount = roleResults.count
                    // 最后删除
                    if resultCount > 0 {
                        for obj in roleResults {
                            
                            var newRole = AVObject(className: AVObject.ClassName_Role)
                            newRole.roleName = obj.name
                            newRole.roleDesp = obj.desp
                            newRole.roleAvatars = obj.avatarUrls as? [String]
                            
                            if newRole.save(&error) {
                                managedObjCtx?.deleteObject(obj)
                            }
                        }
                        fetchOffset += resultCount
                    } else {
                        hasMore = false
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    SVProgressHUD.showSuccessWithStatus("上传群组和角色数据成功")
                    
                    strongSelf.localRoleGroupCountLabel?.text = "\(0)"
                    strongSelf.localRoleCountLabel?.text = "\(0)"
                }
            }
        }
    }
}

