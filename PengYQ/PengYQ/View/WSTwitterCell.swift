//
//  WSTwitterCell.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/9.
//
//

import UIKit
import Haneke
import Kingfisher
import MHPrettyDate

/// 动态信息
class WSTwitterCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: protocol<WSTwitterCellDelegate, TwitterCommentShowViewDelegate>? {
        get {
            return self.delegate
        }
        set (newValue){
            commentShowView?.delegate = newValue
        }
    }
    
    var showTopSeperator: Bool {
        get {
            return self.showTopSeperator
        }
        set (newValue) {
            topSeperator?.hidden = !newValue
        }
    }
    
    @IBOutlet private weak var topSeperator: UIView?
    @IBOutlet private weak var topSeperatorHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var avatarView: UIImageView?
    @IBOutlet private weak var twitterTextView: UITextView?
    @IBOutlet private weak var photosCollectionView: UICollectionView?
    @IBOutlet private weak var createDateLabel: UILabel?
    @IBOutlet private weak var moreOperateButton: UIButton?
    @IBOutlet private weak var commentShowView: TwitterCommentShowView?
    
    @IBOutlet private weak var twitterTextViewTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var twitterTextViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var photosCollectionViewTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var photosCollectionViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var commentShowViewTopConstraint: NSLayoutConstraint?
    @IBOutlet private weak var commentShowViewHeightConstraint: NSLayoutConstraint?
    
    private var photoURLs: [NSURL]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topSeperator?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        topSeperatorHeightConstraint?.constant = 0.5
        twitterTextView?.backgroundColor = UIColor.clearColor()
        
        photosCollectionView?.backgroundColor = UIColor.clearColor()
        photosCollectionView?.registerClass(TwitterPhotoCell.self, forCellWithReuseIdentifier: WSTwitterPhotoCellReuseIdentifier)
        photosCollectionView?.delegate = self
        photosCollectionView?.dataSource = self
//        let photosCollectionViewLayout = photosCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
//        photosCollectionViewLayout.itemSize = CGSizeMake(WSTwitterPhotoSize, WSTwitterPhotoSize)
//        photosCollectionViewLayout.minimumLineSpacing = WSTwitterPhotoMinimumLineSpacing
//        photosCollectionViewLayout.minimumInteritemSpacing = WSTwitterPhotoMinimumInteritemSpacing
        
        createDateLabel?.backgroundColor = UIColor.clearColor()
        
        moreOperateButton?.addTarget(self, action: "clickMoreOperateButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        commentShowView?.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoURLs != nil {
            return photoURLs!.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(WSTwitterPhotoCellReuseIdentifier, forIndexPath: indexPath) as! TwitterPhotoCell
        
//        imageView?.hnk_setImageFromURL(photoURLs![indexPath.row], placeholder: UIImage(named: "Twitter_photo_default_background"))
        
        cell.configWithPhotoURL(photoURLs![indexPath.row])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        delegate?.twitterCell?(self, didSelectPhotoViewAtIndex:indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WSTwitterPhotoSize, WSTwitterPhotoSize)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return WSTwitterPhotoMinimumLineSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return WSTwitterPhotoMinimumInteritemSpacing
    }
    
    func configWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat = 0) {
        
        let avatarURL = data?[WSTwitterCellTwitterDataKey_avatarURL] as? NSURL
        let authorName = data?[WSTwitterCellTwitterDataKey_authorName] as? String
        let textContent = data?[WSTwitterCellTwitterDataKey_textContent] as? String
        let photoURLs = data?[WSTwitterCellTwitterDataKey_photoURLs] as? [NSURL]
        let createDate = data?[WSTwitterCellTwitterDataKey_createDate]  as? NSDate
        let comments = data?[WSTwitterCellTwitterDataKey_comments] as? [[String: AnyObject]]
        let zans = data?[WSTwitterCellTwitterDataKey_zanUserNames] as? [String]
        
        let twitterTextViewWidth = cellWidth - WSTwitterTextViewLittleThanCellWidth
        
        // 设置头像
        if avatarURL != nil {
            avatarView?.hnk_setImageFromURL(avatarURL!, placeholder: UIImage(named: "RoleAvatar"))
        } else {
//            avatarView?.hnk_setImage(UIImage(named: "RoleAvatar")!, animated: false, success: nil)
            avatarView?.hnk_cancelSetImage()
            avatarView?.image = UIImage(named: "RoleAvatar")
        }
        
        // 设置文字内容
        let twitterAttributedText = WSTwitterCell.buildTwitterTextViewAttributedTextWithAuthorName(authorName, twitterTextContent:textContent)
        twitterTextView?.attributedText = twitterAttributedText
        
        twitterTextViewHeightConstraint?.constant = WSTwitterCell.twitterTextViewHeightWithAttributedText(twitterAttributedText, twitterTextViewWidth:twitterTextViewWidth)
        
        // 设置图片
        self.photoURLs = photoURLs
        photosCollectionView?.reloadData()
        
        if let photoCount = photoURLs?.count {
            photosCollectionViewTopConstraint?.constant = WSTwitterPhotosCollectionViewTopMargin
            
            photosCollectionViewHeightConstraint?.constant = WSTwitterCell.caculatePhtotosCollectionViewHeightWithPhotoNumber(photoNumber: photoCount, collectionViewWidth: twitterTextViewWidth)
        } else {
            photosCollectionViewTopConstraint?.constant = 0
            photosCollectionViewHeightConstraint?.constant = 0
        }
        
        // 设置时间
        if createDate != nil {
            createDateLabel?.text = MHPrettyDate.prettyDateFromDate(createDate, withFormat: MHPrettyDateFormatWithTime)
        } else {
            createDateLabel?.text = nil
        }
        
        // 设置评论视图
        var commentShowViewData = [String: AnyObject]()
        if zans != nil {
            commentShowViewData[TwitterCommentShowViewTwitterDataKey_zanUserNames] = zans!
        }
        
        if comments != nil {
            commentShowViewData[TwitterCommentShowViewTwitterDataKey_comments] = comments!
        }
        
        commentShowView?.configWithData(data: commentShowViewData, viewWidth: twitterTextViewWidth)
    }
    
    class func cellHeightWithData(data: [String: AnyObject]? = nil, cellWidth: CGFloat? = 0) -> CGFloat {
        
        // TODO:
        
        return 0
    }
    
    static private func buildTwitterTextViewAttributedTextWithAuthorName(authorName: String?, twitterTextContent: String?) -> NSAttributedString? {
        let attributedText = NSMutableAttributedString()
        
        // 动态发布者名字
        if authorName?.isEmpty == false {
            let namePS = NSMutableParagraphStyle()
            namePS.lineSpacing = 2
            namePS.paragraphSpacing = 8
            attributedText.appendAttributedString(NSAttributedString(string:authorName!, attributes:[NSFontAttributeName:UIFont.systemFontOfSize(18), NSForegroundColorAttributeName:UIColor.blackColor(), NSParagraphStyleAttributeName:namePS]))
        }
        
        // 角色描述
        if twitterTextContent?.isEmpty == false {
            if attributedText.length > 0 {
                attributedText.appendAttributedString(NSAttributedString(string: "\n"))
            }
            
            let contentPS = NSMutableParagraphStyle()
            contentPS.lineSpacing = 2
            contentPS.paragraphSpacing = 4
            attributedText.appendAttributedString(NSAttributedString(string:twitterTextContent!, attributes:[NSFontAttributeName:UIFont.systemFontOfSize(14), NSForegroundColorAttributeName:UIColor.grayColor(), NSParagraphStyleAttributeName:contentPS]))
        }
        
        return attributedText
    }
    
    static private func twitterTextViewHeightWithAttributedText(attributedText:NSAttributedString?, twitterTextViewWidth:CGFloat? = 0) ->CGFloat {
        
        if attributedText == nil {
            return 0
        }
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var sizingTextView : UITextView? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.sizingTextView = UITextView()
        }
        
        Static.sizingTextView?.attributedText = attributedText
        let sizingTextViewSize = Static.sizingTextView?.sizeThatFits(CGSizeMake(twitterTextViewWidth!, CGFloat(MAXFLOAT)))
        
        return sizingTextViewSize!.height
    }
    
    static private func caculatePhtotosCollectionViewHeightWithPhotoNumber(photoNumber: Int = 0, collectionViewWidth: CGFloat = 0) -> CGFloat {
        
        if photoNumber <= 0 {
            return 0
        }
        
        let columns = Int((collectionViewWidth + WSTwitterPhotoMinimumInteritemSpacing)/(WSTwitterPhotoSize + WSTwitterPhotoMinimumInteritemSpacing))
        if columns <= 0 {
            return 0
        } else {
            let rows = Int(ceilf(Float(photoNumber)/Float(columns)))
            if rows <= 0 {
                return 0
            } else {
                return (CGFloat(rows)*WSTwitterPhotoSize + CGFloat(rows - 1)*WSTwitterPhotoMinimumLineSpacing)
            }
        }
    }
    
    @objc private func clickMoreOperateButton(button: UIButton) {
        delegate?.twitterCell?(self, didClickMoreOprateButton: button)
    }
    
    class TwitterPhotoCell: UICollectionViewCell {
        private var photoView: UIImageView?
        private var retrievePhotoViewImageTask: RetrieveImageTask?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupTwitterPhotoCell()
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configWithPhotoURL(photoURL: NSURL?) {
            if photoURL != nil {
                retrievePhotoViewImageTask = photoView?.kf_setImageWithURL(photoURL!, placeholderImage: UIImage(named: "Twitter_photo_default_background"))
            } else {
                retrievePhotoViewImageTask?.cancel()
            }
        }
        
        private func setupTwitterPhotoCell() {
            
            photoView = UIImageView()
            self.contentView.addSubview(photoView!)
            
            photoView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            photoView?.contentMode = UIViewContentMode.ScaleAspectFill
            
            // 设置约束
            let views = ["photoView":photoView!]
           
            self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[photoView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
            
            self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[photoView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        }
    }
}

@objc protocol WSTwitterCellDelegate {
    
    optional func twitterCell(twitterCell: WSTwitterCell, didClickMoreOprateButton: UIButton)
    
    optional func twitterCell(twitterCell: WSTwitterCell, didSelectPhotoViewAtIndex: Int)
}

let WSTwitterCellMinHeight: CGFloat = 64
let WSTwitterCellTopPadding = 6
let WSTwitterCellBottomPadding = 8

let WSTwitterTextViewLittleThanCellWidth: CGFloat = 72

let WSTwitterPhotosCollectionViewTopMargin: CGFloat = 8
let WSTwitterPhotoSize: CGFloat = 84
let WSTwitterPhotoMinimumLineSpacing: CGFloat = 4
let WSTwitterPhotoMinimumInteritemSpacing: CGFloat = 4
let WSTwitterPhotoCellReuseIdentifier = "WSTwitterPhotoCell"

let WSTwitterCommentShowViewTopMargin: CGFloat = 8


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
