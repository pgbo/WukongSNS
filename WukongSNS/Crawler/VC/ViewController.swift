//
//  ViewController.swift
//  Crawler
//
//  Created by 彭光波 on 15/7/6.
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var originRoleGroupCountLabel:UILabel?
    @IBOutlet private weak var originRoleCountLabel:UILabel?
    @IBOutlet private weak var startCrawlerButton:UIButton?
    @IBOutlet private weak var uploadDataButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCrawlerButton?.addTarget(self, action:"startCrawl", forControlEvents: UIControlEvents.TouchUpInside)
        
        uploadDataButton?.addTarget(self, action:"uploadData", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 获取原数据
        SVProgressHUD.showWithStatus("获取原数据中...")
        
        let groupCountQuery = AVQuery(className: "RoleGroup")
        groupCountQuery.countObjectsInBackgroundWithBlock { [weak self] (groupCount:Int, error:NSError!) -> Void in
            if let strongSelf = self {
                println("groupCount:\(groupCount), error:\(error.description)")
                dispatch_async(dispatch_get_main_queue()){
                    strongSelf.originRoleGroupCountLabel?.text = String("\(groupCount)")
                }
                let roleCountQuery = AVQuery(className: "Role")
                roleCountQuery.countObjectsInBackgroundWithBlock({ [weak strongSelf] (roleCount:Int, error:NSError!) -> Void in
                    if let inStrongSelf = strongSelf {
                        println("roleCount:\(roleCount), error:\(error.description)")
                        dispatch_async(dispatch_get_main_queue()){
                            inStrongSelf.originRoleCountLabel?.text = String("\(roleCount)")
                            if error != nil {
                                SVProgressHUD.showErrorWithStatus(error.description)
                            } else {
                                SVProgressHUD.showSuccessWithStatus("已经存在\(groupCount)个角色组, \(roleCount)个角色")
                            }
                        }
                    }
                })
            }
        }
        
    }

    private func startCrawl() {
        // TODO:
    }
    
    private func uploadData() {
        // TODO:
    }
}

