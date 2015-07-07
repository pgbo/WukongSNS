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

let RoleGroupClassName = "RoleGroup"
let RoleClassName = "Role"
let CrawlMRPYQ_AccessToken = "559651eefbe78e46c231a25e.1466673135.1eec9af45c823eade1100de3aa948d3f"

class ViewController: UIViewController {

    @IBOutlet private weak var originRoleGroupCountLabel:UILabel?
    @IBOutlet private weak var originRoleCountLabel:UILabel?
    @IBOutlet private weak var startCrawlerButton:UIButton?
    @IBOutlet private weak var uploadDataButton:UIButton?
    
    private var crawlRoleGroupDataGroup:dispatch_group_t? = dispatch_group_create()
    private var crawlRoleDataGroup:dispatch_group_t? = dispatch_group_create()
    private var crawlRoleGroupNumber = 0
    private var crawlRoleNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCrawlerButton?.addTarget(self, action:"startCrawl", forControlEvents: UIControlEvents.TouchUpInside)
        
        uploadDataButton?.addTarget(self, action:"uploadData", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIImageView().hnk_setImage(UIImage(), animated: false) { (image:UIImage!) -> () in
            
        }
        
        // 获取原数据
        SVProgressHUD.showWithStatus("获取原数据中...", maskType: SVProgressHUDMaskType.Clear)

        let groupCountQuery = AVQuery(className: RoleGroupClassName)
        groupCountQuery.countObjectsInBackgroundWithBlock { [weak self] (groupCount:Int, error:NSError!) -> Void in
            if let strongSelf = self {
                println("groupCount:\(groupCount), error:\(error.description)")
                dispatch_async(dispatch_get_main_queue()){
                    strongSelf.originRoleGroupCountLabel?.text = String("\(groupCount)")
                }
                let roleCountQuery = AVQuery(className: RoleClassName)
                roleCountQuery.countObjectsInBackgroundWithBlock({ [weak strongSelf] (roleCount:Int, error:NSError!) -> Void in
                    if let inStrongSelf = strongSelf {
                        println("roleCount:\(roleCount), error:\(error.localizedFailureReason)")
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

    internal func startCrawl() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)){ [weak self] () -> Void in
            
            if let ExtStrongSelf = self {
                dispatch_group_enter(ExtStrongSelf.crawlRoleGroupDataGroup!)
                
                // 爬取群组
                SVProgressHUD.showSuccessWithStatus("爬取群组...", maskType: SVProgressHUDMaskType.Clear)
                Alamofire.request(.GET, "http://api.mrpyq.com/user/user_groups?access_token=\(CrawlMRPYQ_AccessToken)").responseJSON(options: NSJSONReadingOptions()) { [weak self] (request, response, dictionary, error) -> Void in
                    if let strongSelf = self {
                        if let jsonObj = dictionary as? [String:AnyObject] {
                            let items = jsonObj["items"] as! [[String:AnyObject]]
                            for itemObj in items {
                                // 保存群组到本地
                                let localGroup = LocalRoleGroup()
                                localGroup.name = (itemObj["name"] as? String)!
                                AppDelegate.instanse().managedObjectContext?.insertObject(localGroup)
                                println("保存角色组到数据库:\(localGroup)")
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
                SVProgressHUD.showSuccessWithStatus("爬取角色...", maskType: SVProgressHUDMaskType.Clear)
                
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
                                    let localRole = LocalRole()
                                    localRole.name = (itemObj["name"] as? String)!
                                    localRole.desp = (itemObj["description"] as? String)!
                                    if let avatars = itemObj["avatars"] as? [[String:AnyObject]] {
                                        var avatarUrls:[String] = []
                                        for avatarObj in avatars {
                                            avatarUrls.append(avatarObj["headimg"] as! String)
                                        }
                                        localRole.avatarUrls = avatarUrls
                                    }
                                    // 保存到本地
                                    AppDelegate.instanse().managedObjectContext?.insertObject(localRole)
                                    println("保存角色到数据库:\(localRole)")
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
                SVProgressHUD.showSuccessWithStatus("抓取的角色群组数量:\(ExtStrongSelf.crawlRoleGroupNumber), 抓取的角色数量:\(ExtStrongSelf.crawlRoleNumber)")
            }
        }
    }
    
    internal func uploadData() {
        // TODO:
    }
}

