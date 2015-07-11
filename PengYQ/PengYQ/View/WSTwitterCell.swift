//
//  WSTwitterCell.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/9.
//
//

import UIKit

/// 动态信息
class WSTwitterCell: UITableViewCell {
    
    @IBOutlet private weak var avatarView: UIImageView?
    @IBOutlet private weak var twitterTextView: UITextView?
    @IBOutlet private weak var photosContaintView: UIView?
    @IBOutlet private weak var createDateLabel: UILabel?
    @IBOutlet private weak var moreOperateButton: UIButton?
    @IBOutlet private weak var commentShowView: TwitterCommentShowView?
    
    @IBOutlet private weak var twitterTextViewTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var twitterTextViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var photosContaintViewTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var photosContaintViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var commentShowViewTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var commentShowViewHeightConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        twitterTextView?.backgroundColor = UIColor.clearColor()
        photosContaintView?.backgroundColor = UIColor.clearColor()
        createDateLabel?.backgroundColor = UIColor.clearColor()
        commentShowView?.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat? = 0) {
        // TODO:
        
        let avatarURL = data?[WSTwitterCellTwitterDataKey_avatarURL]
        let authorName = data?[WSTwitterCellTwitterDataKey_authorName]
        let textContent = data?[WSTwitterCellTwitterDataKey_textContent]
        let photoURLs = data?[WSTwitterCellTwitterDataKey_photoURLs]
        let createDate = data?[WSTwitterCellTwitterDataKey_createDate]
        let comments = data?[WSTwitterCellTwitterDataKey_comments]
        let zans = data?[WSTwitterCellTwitterDataKey_zanUserNames]
        
        
        
    }
    
    class func cellHeightWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat? = 0) -> CGFloat {
        
        // TODO:
        
        return 0
    }

}

let WSTwitterCellMinHeight: CGFloat = 64

 /// 动态的数据key
let WSTwitterCellTwitterDataKey_avatarURL = "WSTwitterCellTwitterDataKey_avatarURL"
let WSTwitterCellTwitterDataKey_authorName = "WSTwitterCellTwitterDataKey_authorName"
let WSTwitterCellTwitterDataKey_textContent = "WSTwitterCellTwitterDataKey_textContent"
let WSTwitterCellTwitterDataKey_photoURLs = "WSTwitterCellTwitterDataKey_photoURLs"
let WSTwitterCellTwitterDataKey_createDate = "WSTwitterCellTwitterDataKey_createDate"
// 动态的评论数据，每条评论的具体信息再通过评论的数据key获取
let WSTwitterCellTwitterDataKey_comments = "WSTwitterCellTwitterDataKey_comments"
// 动态的点赞用户
let WSTwitterCellTwitterDataKey_zanUserNames = "WSTwitterCellTwitterDataKey_zanUserNames"

// 评论的数据key
let WSTwitterCellCommentDataKey_authorName = "WSTwitterCellCommentDataKey_authorName"
let WSTwitterCellCommentDataKey_atUserName = "WSTwitterCellCommentDataKey_atUserName"
let WSTwitterCellCommentDataKey_textContent = "WSTwitterCellCommentDataKey_textContent"
