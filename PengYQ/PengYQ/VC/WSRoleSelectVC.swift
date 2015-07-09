//
//  WSRoleSelectVC.swift
//  WukongSNS
//
//  Created by 彭光波 on 15/7/4.
//
//

import UIKit
import UpRefreshControl
import UpLoadMoreControl
import AVOSCloud
import SVProgressHUD

class WSRoleSelectVC: UITableViewController {

    var delegate: WSRoleSelectVCDelegate?
    
    private var roles = [AVObject]()
    private var firstAppear = false
    
    private var upRefreshControl:UpRefreshControl?
    private var upLoadMoreControl:UpLoadMoreControl?
    
    class func initFromStoryboard() -> WSRoleSelectVC {
        let vc: WSRoleSelectVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WSRoleSelectVC") as! WSRoleSelectVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "扮演角色"
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        upRefreshControl = UpRefreshControl(scrollView: self.tableView, action: { (control) -> Void in
            
            let roleQuery = AVQuery(className: AVObject.ClassName_Role)
            roleQuery?.limit = 30
            roleQuery?.findObjectsInBackgroundWithBlock({ [weak self] (results, error) -> Void in
                if let strongSelf = self {
                    dispatch_async(dispatch_get_main_queue()) {
                        strongSelf.upRefreshControl?.finishedLoadingWithStatus("", delay: 0)
                    }
                    if error != nil {
                        println(error?.localizedFailureReason)
                    } else {
                        let roleResults = results as? [AVObject]
                        if roleResults != nil {
                            dispatch_async(dispatch_get_main_queue()) {
                                strongSelf.roles = roleResults!
                                strongSelf.tableView.reloadData()
                            }
                        }
                    }
                }
            })
        })
        tableView.addSubview(upRefreshControl!)
        
        upLoadMoreControl = UpLoadMoreControl(scrollView: self.tableView, action: { [weak self] (control) -> Void in
            if let strongSelf = self {
                
                let roleQuery = AVQuery(className: AVObject.ClassName_Role)
                roleQuery?.skip = strongSelf.roles.count
                roleQuery?.limit = 30
                roleQuery?.findObjectsInBackgroundWithBlock({ [weak strongSelf] (results, error) -> Void in
                    if let internalStrongSelf = strongSelf {
                        dispatch_async(dispatch_get_main_queue()) {
                            internalStrongSelf.upLoadMoreControl?.finishedLoadingWithStatus("", delay: 0)
                        }
                        if error != nil {
                            println(error?.localizedFailureReason)
                        } else {
                            let roleResults = results as? [AVObject]
                            if roleResults != nil {
                                dispatch_async(dispatch_get_main_queue()) {
                                    
                                    let orginCount = internalStrongSelf.roles.count
                                    let newQueryCount = (roleResults?.count)!
                                    var insetsIndexPaths = [NSIndexPath]()
                                    for index in 0...(newQueryCount - 1) {
                                        insetsIndexPaths.append(NSIndexPath(forRow: orginCount + index, inSection: 0))
                                    }
                                    
                                    internalStrongSelf.roles += roleResults!
                                    
                                    internalStrongSelf.tableView.insertRowsAtIndexPaths(insetsIndexPaths, withRowAnimation: UITableViewRowAnimation.None);
                                }
                            }
                        }
                    }
                })
            }
        })
        tableView.addSubview(upLoadMoreControl!)
        
    }

    override func didReceiveMemoryWarning() {
        roles.removeAll()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recvRoleSelectButtonClickNote:", name: WSSelectRoleCellSelectButtonClickNotification, object: nil)
        
        if firstAppear == false {
            firstAppear = true
            SVProgressHUD.showWithStatus("努力加载...", maskType: SVProgressHUDMaskType.Black)
            let roleQuery = AVQuery(className: AVObject.ClassName_Role)
            roleQuery?.limit = 30
            roleQuery?.findObjectsInBackgroundWithBlock({ [weak self] (results, error) -> Void in
                if let strongSelf = self {
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            SVProgressHUD.showErrorWithStatus(error?.localizedFailureReason, maskType: SVProgressHUDMaskType.Black)
                        }
                    } else {
                        let roleResults = results as? [AVObject]
                        if roleResults != nil {
                            strongSelf.roles = roleResults!
                            strongSelf.tableView.reloadData()

                            dispatch_async(dispatch_get_main_queue()) {
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
            })
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WSSelectRoleCellSelectButtonClickNotification, object: nil)
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WSSelectRoleCellReuseIdentifier, forIndexPath: indexPath) as! WSSelectRoleCell
        
        // Configure the cell...
        
        cell.showTopSeperator = indexPath.row != 0
        
        cell.configWithData(buildSelectRoleCellNeededDataWithRole(roles[indexPath.row]), cellWidth: CGRectGetWidth(tableView.bounds))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return WSSelectRoleCell.cellHeightWithData(buildSelectRoleCellNeededDataWithRole(roles[indexPath.row]), cellWidth: CGRectGetWidth(tableView.bounds))
    }
    
    
    private func buildSelectRoleCellNeededDataWithRole(role:AVObject!) -> [String:AnyObject]! {
        
        var data = [String:AnyObject]()
        data[WSSelectRoleCellDataKey_roleName] = role.roleName
        data[WSSelectRoleCellDataKey_roleDescription] = role.roleDesp
        
        if role.roleAvatars != nil {
            var avaliableAvatarURL:NSURL?
            for avatarUrl in role.roleAvatars! {
                avaliableAvatarURL = NSURL(string: avatarUrl)
                if avaliableAvatarURL != nil {
                    break
                }
            }
            if avaliableAvatarURL != nil {
                data[WSSelectRoleCellDataKey_roleAvatarURL] = avaliableAvatarURL
            }
        }
        
        return data
    }
    
    @objc private func recvRoleSelectButtonClickNote(notification:NSNotification!) {
        println("recvRoleSelectButtonClickNote.")
        
        let selectedButton = notification.userInfo?[kWSSelectRoleCellSelectButton] as? UIButton
        if selectedButton != nil {
            let p = tableView.convertPoint(CGPoint(x: 0, y: 0), fromView: selectedButton)
            if let clickIndexPath = tableView.indexPathForRowAtPoint(p) {
                println("clickIndexPath.row: \(clickIndexPath.row)")
                let selectRole: AVObject! = roles[clickIndexPath.row]
                delegate?.roleSelectVC?(self, didSelectRole:selectRole)
            }
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.upRefreshControl?.scrollViewDidScroll()
        self.upLoadMoreControl?.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.upRefreshControl?.scrollViewDidEndDragging()
        self.upLoadMoreControl?.scrollViewDidEndDragging()
    }
}


@objc protocol WSRoleSelectVCDelegate {
    optional func roleSelectVC(vc:WSRoleSelectVC, didSelectRole:AVObject)
}

