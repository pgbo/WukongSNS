//
//  TwitterCommentShowView.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/9.
//
//

import UIKit
import DWTagList
import TTTAttributedLabel

@objc protocol TwitterCommentShowViewDelegate {
    
    optional func twitterCommentShowView(view: TwitterCommentShowView, didSelectCommentIndex: Int)
    
    optional func twitterCommentShowView(view: TwitterCommentShowView, didSelectCommentUserName: String)

    optional func twitterCommentShowView(view: TwitterCommentShowView, didSelectZanUserName: String, atIndex: Int)
}


/// 动态评论展示视图
class TwitterCommentShowView: UIView, UITableViewDelegate, UITableViewDataSource, TwitterCommentCellDelegate, DWTagListDelegate {
    
    weak var delegate: TwitterCommentShowViewDelegate?
    
    private var backgroudBoxImageView: UIImageView?
    private var likesTagView: DWTagList?
    private var likeIconView: UIImageView?
    private var likesCommentsSeperatorView: UIView?
    private var commentsTable: UITableView?
    
    private var likesTagViewHeightConstraint: NSLayoutConstraint?
    private var likesCommentsSeperatorViewTopConstraint: NSLayoutConstraint?
    private var likesCommentsSeperatorViewHeightConstraint: NSLayoutConstraint?
    private var commentsTableTopConstraint: NSLayoutConstraint?
    private var commentsTableHeightConstraint: NSLayoutConstraint?
    
    private var comments: [[String: AnyObject]]??
    private var zanUserNames: [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTwitterCommentShowView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTwitterCommentShowView()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments != nil {
            return comments!!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TwitterCommentCell.cellHeightWithData(data: comments!![indexPath.row], cellWidth: CGRectGetWidth(tableView.bounds))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TwitterCommentCellReuseIdentifer, forIndexPath: indexPath) as! TwitterCommentCell
        
        cell.delegate = self
        cell.configWithData(data: comments!![indexPath.row], cellWidth: CGRectGetWidth(tableView.bounds))
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.twitterCommentShowView?(self, didSelectCommentIndex: indexPath.row)
    }
    
    
    // MARK: - TwitterCommentCellDelegate
    
    func twitterCommentCell(cell: TwitterCommentCell!, didSelectUserName: String!) {
        delegate?.twitterCommentShowView?(self, didSelectCommentUserName: didSelectUserName)
    }
    
    // MARK: - DWTagListDelegate
    
    func selectedTag(tagName: String!, tagIndex: Int) {
        println("selectedTag:\(tagName), tagIndex:\(tagIndex)")
        if tagName != TwitterLikeIconPlaceHolderTagString && tagName != TwitterLikeTagSeperatorString && zanUserNames != nil {
            
            // FIXME: 获取真正的index，升级到swift2.0 使用indexOf方法
            var realIndex = 0
            
            for (index, value) in enumerate(zanUserNames!) {
                if value == tagName {
                    realIndex = index
                    delegate?.twitterCommentShowView?(self, didSelectZanUserName: tagName, atIndex:realIndex)
                    break
                }
            }
        }
    }
    
    
    func configWithData(data: [String: AnyObject]? = nil, viewWidth: CGFloat? = 0) {
        
        let zanUserNames = data?[TwitterCommentShowViewTwitterDataKey_zanUserNames] as? [String]
        let comments = data?[TwitterCommentShowViewTwitterDataKey_comments] as? [[String:AnyObject]]?
        
        // 设置赞视图
        self.zanUserNames = zanUserNames
        
        let builedTags = TwitterCommentShowView.buildTagsWithZanNames(zanUserNames, seperateString:TwitterLikeTagSeperatorString)
        if builedTags == nil {
            likesTagView?.setTags([String]())
            likesTagViewHeightConstraint?.constant = 0
            likeIconView?.hidden = true
        } else {
            likesTagView?.setTags(builedTags)
            likesTagViewHeightConstraint?.constant = TwitterCommentShowView.caculateLikesTagViewHeightWithZanUserNames(names: zanUserNames, likesTagViewWidth: viewWidth)
            likeIconView?.hidden = false
        }
        
        // 设置分割线
        if zanUserNames?.count > 0 && comments??.count > 0 {
            likesCommentsSeperatorViewTopConstraint?.constant = TwitterCommentShowView_seperatorTopMargin
            likesCommentsSeperatorViewHeightConstraint?.constant = TwitterCommentShowView_seperatorViewHeight
        } else {
            likesCommentsSeperatorViewTopConstraint?.constant = 0
            likesCommentsSeperatorViewHeightConstraint?.constant = 0
        }
        
        // 设置评论视图
        
        self.comments = comments
        commentsTable?.reloadData()
        
        if comments??.count > 0 {
            let commentsTableHeight = TwitterCommentShowView.caculateCommentsTableheightWithComments(comments: comments!, commentsTableWidth: viewWidth)
            commentsTableHeightConstraint?.constant = commentsTableHeight
            if commentsTableHeight > 0 {
                commentsTableTopConstraint?.constant = TwitterCommentShowView_commentsTableTopMargin
            }
        } else {
            commentsTableHeightConstraint?.constant = 0
            commentsTableTopConstraint?.constant = 0
        }
    }
    
    
    /**
    计算视图高度
    
    :param: data
    :param: viewWidth
    
    :returns: 计算出的高度
    */
    static func caculateHeightWithData(data: [String: AnyObject]? = nil, viewWidth: CGFloat? = 0) -> CGFloat {
        
        // 返回计算的高度
        
        var height: CGFloat = 0
        
        let zanUserNames = data?[TwitterCommentShowViewTwitterDataKey_zanUserNames] as? [String]
        let comments = data?[TwitterCommentShowViewTwitterDataKey_comments] as? [[String:AnyObject]]?
        
        // 计算赞相关视图的高度
        if zanUserNames?.count > 0 {
            let likesTagViewHeight = caculateLikesTagViewHeightWithZanUserNames(names: zanUserNames, likesTagViewWidth: viewWidth)
            if likesTagViewHeight > 0 {
                height += TwitterCommentShowView_likesTagViewTopMargin + likesTagViewHeight
            }
        }
        
        // 计算分割线的高度
        if zanUserNames?.count > 0 && comments??.count > 0 {
            height += TwitterCommentShowView_seperatorTopMargin + TwitterCommentShowView_seperatorViewHeight
        }
        
        // 计算评论相关的高度
        if comments??.count > 0 {
            let commentsTableHeight = caculateCommentsTableheightWithComments(comments: comments!, commentsTableWidth: viewWidth)
            if commentsTableHeight > 0 {
                height += TwitterCommentShowView_commentsTableTopMargin + commentsTableHeight
            }
        }
        
        if height > 0 {
            height += TwitterCommentShowView_commentsTableBottomMargin
        }
        
        return height
    }
    
    static private func customLikesTagView(tagView:DWTagList!) {
        tagView.automaticResize = true
        tagView.labelMargin = 4
        tagView.textColor = UIColor.darkGrayColor()
        tagView.font = UIFont.systemFontOfSize(12)
        tagView.borderWidth = 0
        tagView.cornerRadius = 0
    }
    
    /**
    构建赞视图需要的tag集合
    
    :param: tagView
    :param: placeZanNames
    :param: seperateString 各个tag的分割字符
    :returns: 返回创建的
    */
    static private func buildTagsWithZanNames(zanNames: [String]?, seperateString: String? = ",") -> [String]? {
        
        if zanNames?.count > 0 {
            
            var zanNameTags = [String]()
            
            // 为放置❤️图标创建一个占位tag
            zanNameTags.append(TwitterLikeIconPlaceHolderTagString)
            
            var index = 0
            for zanName in zanNames! {
                zanNameTags.append(zanName)
                if seperateString?.isEmpty == false && index < zanNames!.count - 1{
                    zanNameTags.append(seperateString!)
                }
                index += 1
            }
            return zanNameTags
        }
        
        return nil
    }
    
    /**
    计算liketagView的高度
    
    :param: names             赞的用户名称列表
    :param: likesTagViewWidth 赞的视图的宽度
    
    :returns: 计算结果
    */
    static private func caculateLikesTagViewHeightWithZanUserNames(names: [String]? = nil, likesTagViewWidth: CGFloat? = 0) -> CGFloat {
        if names?.count > 0 {
            struct Static {
                static var onceToken : dispatch_once_t = 0
                static var sizingLikesTagView : DWTagList? = nil
            }
            dispatch_once(&Static.onceToken) {
                Static.sizingLikesTagView = DWTagList()
                self.customLikesTagView(Static.sizingLikesTagView!)
            }
            
            var sizingTagViewFrame = Static.sizingLikesTagView!.frame
            if sizingTagViewFrame.size.width != likesTagViewWidth {
                sizingTagViewFrame.size.width = likesTagViewWidth!
                Static.sizingLikesTagView?.frame = sizingTagViewFrame
            }
            
            let builedTags = TwitterCommentShowView.buildTagsWithZanNames(names, seperateString:TwitterLikeTagSeperatorString)
            if builedTags == nil {
                Static.sizingLikesTagView?.setTags([String]())
            } else {
                Static.sizingLikesTagView?.setTags(builedTags)
            }
            
            return Static.sizingLikesTagView!.fittedSize().height
        }
        return 0
    }
    
    /**
    计算评论表格的高度
    
    :param: comments           评论列表
    :param: commentsTableWidth 评论表格的宽度
    
    :returns: 计算结果
    */
    static private func caculateCommentsTableheightWithComments(comments: [[String: AnyObject]]? = nil, commentsTableWidth: CGFloat? = 0) -> CGFloat {
        
        if comments?.count > 0 {
            var height: CGFloat = 0
            
            for comment in comments! {
                height += TwitterCommentCell.cellHeightWithData(data: comment, cellWidth: commentsTableWidth)
            }
            
            return height
        }
        return 0
    }
    
    private func setupTwitterCommentShowView() {
        
        backgroudBoxImageView = UIImageView()
        self.addSubview(backgroudBoxImageView!)
        backgroudBoxImageView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroudBoxImageView?.image = UIImage(named: "Album_likes_comments_background")?.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 15, 1, 1))
        
        likesTagView = DWTagList()
        self.addSubview(likesTagView!)
        likesTagView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        TwitterCommentShowView.customLikesTagView(likesTagView!)
        likesTagView?.tagDelegate = self
        
        likeIconView = UIImageView(image: UIImage(named: "Album_like_icon"))
        self.addSubview(likeIconView!)
        likeIconView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        likesCommentsSeperatorView = UIView()
        self.addSubview(likesCommentsSeperatorView!)
        likesCommentsSeperatorView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        commentsTable = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        self.addSubview(commentsTable!)
        commentsTable?.setTranslatesAutoresizingMaskIntoConstraints(false)
        commentsTable?.separatorStyle = UITableViewCellSeparatorStyle.None
        commentsTable?.showsVerticalScrollIndicator = false
        commentsTable?.scrollEnabled = false
        commentsTable?.registerClass(TwitterCommentCell.self, forCellReuseIdentifier: TwitterCommentCellReuseIdentifer)
        
        // 设置约束
        let views = ["backgroudBoxImageView":backgroudBoxImageView!, "likesTagView":likesTagView!, "likeIconView":likeIconView!, "likesCommentsSeperatorView":likesCommentsSeperatorView!, "commentsTable":commentsTable!]
        
        // 设置backgroudBoxImageView的约束
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroudBoxImageView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroudBoxImageView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        
        // 设置likesTagView的约束
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[likesTagView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        self.addConstraint(NSLayoutConstraint(item: likesTagView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: TwitterCommentShowView_likesTagViewTopMargin))
        
        likesTagViewHeightConstraint = NSLayoutConstraint(item: likesTagView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 0)
        likesTagView?.addConstraint(likesTagViewHeightConstraint!)
        
        // 设置likeIconView的约束
        self.addConstraint(NSLayoutConstraint(item: likeIconView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: TwitterCommentShowView_likeIconTopMargin))
        self.addConstraint(NSLayoutConstraint(item: likeIconView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: TwitterCommentShowView_likeIconLeftMargin))
        
        // 设置likesCommentsSeperatorView的约束
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[likesCommentsSeperatorView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        
        likesCommentsSeperatorViewTopConstraint = NSLayoutConstraint(item: likesCommentsSeperatorView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: likesTagView!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraint(likesCommentsSeperatorViewTopConstraint!)
        
        likesCommentsSeperatorViewHeightConstraint = NSLayoutConstraint(item: likesCommentsSeperatorView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 0)
        likesCommentsSeperatorView?.addConstraint(likesCommentsSeperatorViewHeightConstraint!)
        
        // 设置commentsTable的约束
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[commentsTable]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        
        commentsTableTopConstraint = NSLayoutConstraint(item: commentsTable!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: likesCommentsSeperatorView!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2)
        self.addConstraint(commentsTableTopConstraint!)
        
        commentsTableHeightConstraint = NSLayoutConstraint(item: commentsTable!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 0)
        commentsTable?.addConstraint(commentsTableHeightConstraint!)
        
    }
}

let TwitterCommentShowView_likesTagViewTopMargin: CGFloat = 6
let TwitterCommentShowView_likeIconTopMargin: CGFloat = 8
let TwitterCommentShowView_likeIconLeftMargin: CGFloat = 4
let TwitterCommentShowView_seperatorTopMargin: CGFloat = 0
let TwitterCommentShowView_seperatorViewHeight: CGFloat = 0.5

let TwitterCommentShowView_commentsTableTopMargin: CGFloat = 2
let TwitterCommentShowView_commentsTableBottomMargin: CGFloat = 2

// 赞tag的分割字符
let TwitterLikeTagSeperatorString = ","
// 赞tag视图中为❤️图标占位的tag字符
let TwitterLikeIconPlaceHolderTagString = "     "

let TwitterCommentCellReuseIdentifer = "TwitterCommentCell"


/**
*  评论cell的代理协议
*/
@objc protocol TwitterCommentCellDelegate {
    
    /**
    选中用户名字
    
    :param: cell
    :param: didSelectUserName
    */
    optional func twitterCommentCell(cell: TwitterCommentCell!, didSelectUserName: String!)
}

/**
*  评论cell
*/
class TwitterCommentCell: UITableViewCell, TTTAttributedLabelDelegate {
    
    static private let TwitterCommentLabelFontSize: CGFloat = 12
    private let CustomDetectUserNameURLProtocol = "PengYQUser://"
    
    weak var delegate: TwitterCommentCellDelegate?
    
    private var commentLabel: TTTAttributedLabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTwitterCommentCell()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    配置视图
    
    :param: data        数据
    :param: cellWidth   cell宽度
    */
    func configWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat? = 0) {
        
        let authorName = data?[TwitterCommentShowViewCommentDataKey_authorName] as? String
        let atUserName = data?[TwitterCommentShowViewCommentDataKey_atUserName] as? String
        let textContent = data?[TwitterCommentShowViewCommentDataKey_textContent] as? String
        
        let buildResult = TwitterCommentCell.buildCommentTextWithData(data)
        let authorNameRange = buildResult.authorNameRange
        let atUserNameRange = buildResult.atUserNameRange
        let builedCommentText = buildResult.builedCommentText
        
        if builedCommentText.isEmpty == false {
            commentLabel?.setText(builedCommentText, afterInheritingLabelAttributesAndConfiguringWithBlock: { (mutableAttributedString) -> NSMutableAttributedString! in
                return mutableAttributedString
            })
            
            if authorNameRange.location != NSNotFound {
                commentLabel?.addLinkToURL(NSURL(string: ("\(CustomDetectUserNameURLProtocol)" + "\(authorName)")), withRange: authorNameRange)
            }
            
            if atUserNameRange.location != NSNotFound {
                commentLabel?.addLinkToURL(NSURL(string: ("\(CustomDetectUserNameURLProtocol)" + "\(atUserName)")), withRange: atUserNameRange)
            }
            
        } else {
            commentLabel?.setText(nil)
        }
    }
    
    static private func customCommentLabel(commentLabel:TTTAttributedLabel?) {
        commentLabel?.font = UIFont.systemFontOfSize(TwitterCommentLabelFontSize)
        commentLabel?.textColor = UIColor.darkGrayColor()
        commentLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        commentLabel?.numberOfLines = 0
    }
    
    
    /**
    计算高度
    
    :param: data      评论数据
    :param: cellWidth cell宽度
    */
    static func cellHeightWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat? = 0) -> CGFloat {
        
        var height: CGFloat = 0
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var sizingLabel : TTTAttributedLabel? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.sizingLabel = TTTAttributedLabel(frame: CGRectZero)
            self.customCommentLabel(Static.sizingLabel)
        }
        
        var sizingLabelFrame = Static.sizingLabel!.frame
        if sizingLabelFrame.size.width != cellWidth || sizingLabelFrame.size.height != CGFloat.max {
            sizingLabelFrame.size.width = cellWidth!
            sizingLabelFrame.size.height = CGFloat.max
            Static.sizingLabel?.frame = sizingLabelFrame
        }
        
        Static.sizingLabel?.text = buildCommentTextWithData(data).builedCommentText
        
        Static.sizingLabel?.sizeToFit()
        
        let labelHeight = Static.sizingLabel!.frame.height
        if labelHeight > 0 {
            height += TwitterCommentCellTopPadding + TwitterCommentCellBottomPadding
        }
        
        return height > TwitterCommentCellMinHeight ?height:TwitterCommentCellMinHeight
    }
    
    /**
    构建评论内容，返回包含评论者名字的range、@用户名字的range和构建的内容的元组
    
    :param: data
    
    :returns: 包含评论者名字的range、@用户名字的range和构建的内容的元组
    */
    static private func buildCommentTextWithData(data: [String: AnyObject]?) -> (authorNameRange:NSRange, atUserNameRange:NSRange, builedCommentText:String) {
        
        let authorName = data?[TwitterCommentShowViewCommentDataKey_authorName] as? String
        let atUserName = data?[TwitterCommentShowViewCommentDataKey_atUserName] as? String
        let textContent = data?[TwitterCommentShowViewCommentDataKey_textContent] as? String
        
        var builedCommentText = ""
        
        var authorNameRange = NSMakeRange(NSNotFound, 0)
        if authorName?.isEmpty == false {
            builedCommentText += authorName!
            authorNameRange.location = 0
            authorNameRange.length = count(authorName!)
        }
        
        var atUserNameRange = NSMakeRange(NSNotFound, 0)
        if atUserName?.isEmpty == false {
            builedCommentText += "回复"
            
            atUserNameRange.location = count(builedCommentText)
            atUserNameRange.length = count(atUserName!)
           
            builedCommentText += atUserName!
        }
        
        if builedCommentText.isEmpty == false {
            builedCommentText += ":"
        }
        
        if textContent?.isEmpty == false {
            builedCommentText += textContent!
        }
        
        return (authorNameRange, atUserNameRange, builedCommentText)
    }
    
    
    private func setupTwitterCommentCell() {
        commentLabel = TTTAttributedLabel(frame: self.contentView.bounds)
        self.contentView.addSubview(commentLabel!)
        
        commentLabel?.autoresizingMask = UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.FlexibleWidth
        
        TwitterCommentCell.customCommentLabel(commentLabel)
        
        commentLabel?.delegate = self
        commentLabel?.linkAttributes = [NSUnderlineStyleAttributeName:false]
        commentLabel?.activeLinkAttributes = [kTTTBackgroundFillColorAttributeName:UIColor(white: 0.4, alpha: 1).CGColor, NSUnderlineStyleAttributeName:false]
    }
    
    // MARK: - TTTAttributedLabelDelegate
    
    private func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        if let urlString = url.absoluteString {
            let selectUserName = urlString.substringFromIndex(advance(urlString.startIndex, count(CustomDetectUserNameURLProtocol)))
            if selectUserName.isEmpty != false {
                delegate?.twitterCommentCell?(self, didSelectUserName: selectUserName)
            }
        }
    }
}


let TwitterCommentCellTopPadding: CGFloat = 2
let TwitterCommentCellBottomPadding: CGFloat = 2
let TwitterCommentCellMinHeight: CGFloat = 16


// 动态的评论数据，每条评论的具体信息再通过评论的数据key获取
let TwitterCommentShowViewTwitterDataKey_comments = "TwitterCommentShowViewTwitterDataKey_comments"
// 动态的点赞用户
let TwitterCommentShowViewTwitterDataKey_zanUserNames = "TwitterCommentShowViewTwitterDataKey_zanUserNames"

// 评论的数据key
let TwitterCommentShowViewCommentDataKey_authorName = "TwitterCommentShowViewCommentDataKey_authorName"
let TwitterCommentShowViewCommentDataKey_atUserName = "TwitterCommentShowViewCommentDataKey_atUserName"
let TwitterCommentShowViewCommentDataKey_textContent = "TwitterCommentShowViewCommentDataKey_textContent"
