//
//  WSPengYQVC.swift
//  PengYQ
//
//  Created by guangbo on 15/7/9.
//
//

import UIKit
import Haneke
import AVOSCloud

/**
*  朋友圈VC
*/
class WSPengYQVC: UITableViewController, WSRoleSelectVCDelegate {
    
    /**
    *  header view
    */
    class PengYQHeaderView: UIView {
        private(set) var backgroundImageView:UIImageView?
        private(set) var avatarView:UIImageView?
        private var avatarContaintView:UIView?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundImageView = UIImageView()
            self.addSubview(backgroundImageView!)
            backgroundImageView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            avatarContaintView = UIView()
            self.addSubview(avatarContaintView!)
            avatarContaintView?.backgroundColor = UIColor.whiteColor()
            avatarContaintView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            avatarView = UIImageView()
            avatarContaintView?.addSubview(avatarView!)
            avatarView?.contentMode = UIViewContentMode.ScaleAspectFit
            avatarView?.clipsToBounds = true
            avatarView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            let views = ["backgroundImageView":backgroundImageView!, "avatarContaintView":avatarContaintView!, "avatarView":avatarView!]
            
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundImageView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundImageView]-20-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
            
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[avatarContaintView(80)]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[avatarContaintView(80)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
            
            avatarContaintView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[avatarView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
            avatarContaintView?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[avatarView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            avatarContaintView?.layer.borderColor = UIColor(white: 0.7, alpha: 1).CGColor
            avatarContaintView?.layer.borderWidth = 0.5
        }
    }
    
    private var pengYQHeader: PengYQHeaderView?
    private var roleSelectVC: WSRoleSelectVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.title = "有趣*朋友圈"
        
        // 设置导航栏左item
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let lastPlayedRoleName = userDefaults.stringForKey(UD_kLastPlayedRoleName)
        let lastPlayedRoleDesp = userDefaults.stringForKey(UD_kLastPlayedRoleDesp)
        let lastPlayedRoleAvatars = userDefaults.arrayForKey(UD_kLastPlayedRoleAvatars) as? [String]
        
        var showAvatarURL: NSURL?
        if lastPlayedRoleAvatars?.count > 0 {
            showAvatarURL = NSURL(string: lastPlayedRoleAvatars![0])
        }
        self.navigationItem.leftBarButtonItem = createAvatarBarButtonItemWithAvatarURL(avatarURL: showAvatarURL, target:self, action: "clickAtRoleAvatarBarItem")
        
        // 设置导航栏右item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "toMakeATwitter")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(white: 0.6, alpha: 1)
        
        // 设置朋友圈header
        pengYQHeader = PengYQHeaderView(frame: CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 180))
        self.tableView.tableHeaderView = pengYQHeader
        
        pengYQHeader?.backgroundImageView?.userInteractionEnabled = true
        pengYQHeader?.backgroundImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapPengYQHeaderBackgroundView"))
        pengYQHeader?.backgroundImageView?.image = UIImage(named: "BackgroundGray")
        
        pengYQHeader?.avatarView?.userInteractionEnabled = true
        pengYQHeader?.avatarView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapPengYQHeaderAvatarView"))
        if showAvatarURL != nil {
            pengYQHeader?.avatarView?.hnk_setImageFromURL(showAvatarURL!, placeholder: UIImage(named: "RoleAvatar"))
        } else {
            pengYQHeader?.avatarView?.image = UIImage(named: "RoleAvatar")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    
    func roleSelectVC(vc:WSRoleSelectVC, didSelectRole:AVObject) {
        self.navigationController?.popViewControllerAnimated(true)
        println("didSelectRole:\(didSelectRole)")
    }
    
    
    // MARK: - Private methods
    
    private func createAvatarBarButtonItemWithAvatarURL(avatarURL:NSURL? = nil, target: AnyObject? = nil, action: Selector? = nil) -> UIBarButtonItem {
        
        let customButn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        customButn.bounds = CGRectMake(0, 0, 32, 32)
        if avatarURL != nil {
            customButn.hnk_setImageFromURL(avatarURL!, state: UIControlState.Normal, placeholder: UIImage(named: "RoleAvatar"))
        } else {
            customButn.setImage(UIImage(named: "CircleDefaultAvatar"), forState: UIControlState.Normal)
        }
        customButn.imageEdgeInsets = UIEdgeInsetsZero
        if target != nil && action != nil {
            customButn.addTarget(target!, action: action!, forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        return UIBarButtonItem(customView: customButn)
    }
    
    // 点击导航栏头像item
    @objc private func clickAtRoleAvatarBarItem() {
        println("到选取角色页面")
        if roleSelectVC == nil {
            roleSelectVC = WSRoleSelectVC.initFromStoryboard()
            weak var weakSelf = self
            roleSelectVC?.delegate = weakSelf
        }
        self.showViewController(roleSelectVC!, sender: self.navigationController)
    }
    
    // 到发推页面
    @objc private func toMakeATwitter() {
        println("到发推页面")
        self.presentViewController(UINavigationController(rootViewController: WSCreateTwitterVC()), animated: true, completion: nil)
    }
    
    @objc private func tapPengYQHeaderBackgroundView() {
        println("到选取背景照片页面")
    }
    
    @objc private func tapPengYQHeaderAvatarView() {
        println("到选取头像照片页面")
    }
}
