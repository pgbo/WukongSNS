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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat? = 0) {
    
    }
    
    class func cellHeightWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat? = 0) -> CGFloat {
        return 0
    }

}

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
let WSTwitterCellCommentDataKey_atUserNames = "WSTwitterCellCommentDataKey_atUserNames"
let WSTwitterCellCommentDataKey_textContent = "WSTwitterCellCommentDataKey_textContent"
