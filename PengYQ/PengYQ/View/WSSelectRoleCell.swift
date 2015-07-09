//
//  WSSelectRoleCell.swift
//  WukongSNS
//
//  Created by 彭光波 on 15/7/4.
//
//

import UIKit
import Haneke

let WSSelectRoleCellReuseIdentifier = "WSSelectRoleCell"

let RoleTextViewWidthLittleThanCell = CGFloat(144.0);
let WSSelectRoleCellMinHeight = CGFloat(65.0)
let RoleTextViewMarginCellTop = CGFloat(8.0)
let RoleTextViewMarginCellBottom = CGFloat(8.0)

class WSSelectRoleCell: UITableViewCell {
    
    @IBOutlet private weak var topSeperator:UIView?
    @IBOutlet private weak var topSeperatorHeightConstrait:NSLayoutConstraint?
    @IBOutlet private weak var roleTextView:UITextView?
    @IBOutlet private weak var roleAvatarView:UIImageView?
    @IBOutlet private weak var selectRoleButton:UIButton?
    @IBOutlet private weak var roleTextViewHeightConstrait:NSLayoutConstraint?

    var showTopSeperator:Bool {
        get {
            return self.showTopSeperator
        }
        
        set(ifShow) {
            topSeperator?.hidden = !ifShow
        }
    }
    
    /**
    设置数据，配置cell
    
    :param: data 数据
    */
    func configWithData(data:[String:AnyObject]!, cellWidth:CGFloat!) {
        let roleName = data[WSSelectRoleCellDataKey_roleName] as? String
        let roleDescription = data[WSSelectRoleCellDataKey_roleDescription] as? String
        let roleAvatarURL = data[WSSelectRoleCellDataKey_roleAvatarURL] as? NSURL
        
        // 设置内容
        let attributedText = WSSelectRoleCell.buildRoleTextViewAttributedTextWithName(roleName, description: roleDescription)
        roleTextView?.attributedText = attributedText
        
        // 改变约束
        roleTextViewHeightConstrait?.constant = WSSelectRoleCell.roleTextViewHeightWithAttributedText(attributedText, roleTextViewWidth:(cellWidth! - RoleTextViewWidthLittleThanCell))
        
        
        // 设置头像
        roleAvatarView!.hnk_setImageFromURL(roleAvatarURL!, placeholder:UIImage(named: "RoleAvatar"))
    }
    
    /**
    计算cell高度
    
    :param: data      数据
    :param: cellWidth cell的宽度
    
    :returns:
    */
    static func cellHeightWithData(data:[String:AnyObject]!, cellWidth:CGFloat?) ->CGFloat {
        let roleName: AnyObject? = data?[WSSelectRoleCellDataKey_roleName]
        let roleDescription: AnyObject? = data?[WSSelectRoleCellDataKey_roleDescription]
        
        let name = roleName as! String
        let description = roleDescription as! String
        
        // 设置内容
        let attributedText = WSSelectRoleCell.buildRoleTextViewAttributedTextWithName(name, description: description)
        
        let roleTextViewHeight = WSSelectRoleCell.roleTextViewHeightWithAttributedText(attributedText, roleTextViewWidth:(cellWidth! - RoleTextViewWidthLittleThanCell))
        
        let cellHeight = (RoleTextViewMarginCellTop + RoleTextViewMarginCellBottom + roleTextViewHeight)
        
        return cellHeight > WSSelectRoleCellMinHeight ?cellHeight:WSSelectRoleCellMinHeight
    }
    
    /**
    获取roleTextView的高度
    
    :param: attributedText      内容
    :param: roleTextViewWidth   视图宽度
    */
    static func roleTextViewHeightWithAttributedText(attributedText:NSAttributedString?, roleTextViewWidth:CGFloat?) ->CGFloat {
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var sizingTextView : UITextView? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.sizingTextView = UITextView()
        }
        
        Static.sizingTextView?.attributedText = attributedText
        let sizingTextViewSize = Static.sizingTextView?.sizeThatFits(CGSizeMake(roleTextViewWidth!, CGFloat(MAXFLOAT)))
        
        return sizingTextViewSize!.height
    }
    
    /**
    构建角色textView的attributed内容
    
    :param: name        role名称
    :param: description role描述
    */
    private static func buildRoleTextViewAttributedTextWithName(name:String?, description:String?) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString()
        
        // 角色名称
        if name?.isEmpty == false {
            let namePS = NSMutableParagraphStyle()
            namePS.lineSpacing = 2
            namePS.paragraphSpacing = 8
            attributedText.appendAttributedString(NSAttributedString(string:name!, attributes:[NSFontAttributeName:UIFont.systemFontOfSize(18), NSForegroundColorAttributeName:UIColor.blackColor(), NSParagraphStyleAttributeName:namePS]))
        }
        
        // 角色描述
        if description?.isEmpty == false {
            if attributedText.length > 0 {
                attributedText.appendAttributedString(NSAttributedString(string: "\n"))
            }
            
            let despPS = NSMutableParagraphStyle()
            despPS.lineSpacing = 2
            despPS.paragraphSpacing = 4
            attributedText.appendAttributedString(NSAttributedString(string:description!, attributes:[NSFontAttributeName:UIFont.systemFontOfSize(14), NSForegroundColorAttributeName:UIColor.grayColor(), NSParagraphStyleAttributeName:despPS]))
        }
        
        return attributedText
    }
    
    
    @objc private func selectButtonClicked(sender:UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(WSSelectRoleCellSelectButtonClickNotification, object: self, userInfo: [kWSSelectRoleCellSelectButton:sender])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = UITableViewCellSelectionStyle.None
        
        topSeperatorHeightConstrait?.constant = 0.5
        topSeperator?.backgroundColor = UIColor.grayColor()
        
        showTopSeperator = false
        
        roleTextView?.backgroundColor = UIColor.clearColor()
        roleTextView?.editable = false
        roleTextView?.scrollEnabled = false
        roleTextView?.showsHorizontalScrollIndicator = false
        roleTextView?.showsVerticalScrollIndicator = false
        roleTextView?.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleBottomMargin
        
        // 设置选择按钮
        let bgImg = UIImage(named: "WhiteButnBg")?.resizableImageWithCapInsets(UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0))
        selectRoleButton?.setBackgroundImage(bgImg, forState: UIControlState.Normal)
        selectRoleButton?.setBackgroundImage(bgImg, forState: UIControlState.Highlighted)
        selectRoleButton?.setTitle("扮演TA", forState: UIControlState.Normal)
        selectRoleButton?.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        selectRoleButton?.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        
        selectRoleButton?.addTarget(self, action:"selectButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}


// 类型为String的角色名字
let WSSelectRoleCellDataKey_roleName = "roleName"

// 类型为String的角色描述
let WSSelectRoleCellDataKey_roleDescription = "roleDescription"

// 类型为NSURL的角色头像URL
let WSSelectRoleCellDataKey_roleAvatarURL = "roleAvatarURL"

/**
*  角色选择通知，在通知的userInfo中使用kWSSelectRoleCellSelectButton获取点击的按钮
*/
let WSSelectRoleCellSelectButtonClickNotification = "WSSelectRoleCellSelectButtonClickNotification"
let kWSSelectRoleCellSelectButton = "kWSSelectRoleCellSelectButton"
