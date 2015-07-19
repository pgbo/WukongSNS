//
//  WSPengYQVC.swift
//  PengYQ
//
//  Created by guangbo on 15/7/9.
//
//

import UIKit
import Kingfisher
import Toucan
import AVOSCloud
import SVProgressHUD
import UpRefreshControl
import UpLoadMoreControl
import LvModelWindow

/**
*  朋友圈VC
*/
class WSPengYQVC: UITableViewController, WSRoleSelectVCDelegate, WSTwitterCellDelegate, TwitterCommentShowViewDelegate, LvModelWindowDelegate, UITextFieldDelegate {
    
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
    private var pengYQHeaderAvatarViewRetrieveImageTask: RetrieveImageTask?
    private var avatarBarButtonRetrieveImageTask: RetrieveImageTask?
    
    private var upRefreshControl:UpRefreshControl?
    private var upLoadMoreControl:UpLoadMoreControl?
    
    private struct TwitterOperateIndexPaths {
        var operateTwitterIndexPath: NSIndexPath?
        var operateCommentIndexPath: NSIndexPath?
        
        init(operateTwitterIndexPath: NSIndexPath, operateCommentIndexPath: NSIndexPath? = nil) {
            self.operateTwitterIndexPath = operateTwitterIndexPath
            self.operateCommentIndexPath = operateCommentIndexPath
        }
    }
    
    private var twitterOperatingIndexPaths: TwitterOperateIndexPaths?   // 正在操作的索引
    
    lazy private var twitterOperateView: TwitterOperateView = {
        let operateView = TwitterOperateView()
        operateView.zanButton?.addTarget(self, action: "doOperateViewZan", forControlEvents: UIControlEvents.TouchUpInside)
        operateView.commentButton?.addTarget(self, action: "doOperateViewComment", forControlEvents: UIControlEvents.TouchUpInside)
        
        return operateView
    }()
    
    lazy private var twitterOperateModelWindow: LvModelWindow = {
        let modelWindow = LvModelWindow(preferStatusBarHidden: false, supportedOrientationPortrait: false, supportedOrientationPortraitUpsideDown: false, supportedOrientationLandscapeLeft: false, supportedOrientationLandscapeRight: false)
        
        modelWindow.windowRootView.userInteractionEnabled = true
        modelWindow.windowRootView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissTwitterOperateModelWindow"))
        
        modelWindow.modelWindowDelegate = self
        modelWindow.windowRootView.addSubview(self.twitterOperateView)
    
        return modelWindow
    }()
    
    private var roleSelectVC: WSRoleSelectVC?
    
    lazy var twitters = [WSTwitter]()
    
    private var loginUser: AVUser?
    
    private var firstAppear = false
    
    // 假评论输入框
    lazy private var fakeCommentInputField: UITextField = {
        
        let fakeTextField = UITextField(frame: CGRectZero)
        fakeTextField.inputAccessoryView = self.fakeCommentInputFieldAccessoryView
        return fakeTextField
    }()
    
    lazy private var fakeCommentInputFieldAccessoryView: UIView = {
        
        let inputAccessoryView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().applicationFrame), 44))
        inputAccessoryView.backgroundColor = UIColor(white: 0.91, alpha: 1)
        
        let commentTextField = self.realCommentInputField
        inputAccessoryView.addSubview(commentTextField)
        
        commentTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        inputAccessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[commentTextField]-8-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["commentTextField" : commentTextField]))
        inputAccessoryView.addConstraint(NSLayoutConstraint(item: commentTextField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: inputAccessoryView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        return inputAccessoryView
    }()
    
    // 真正的评论输入框
    lazy private var realCommentInputField: UITextField = {
        let commentInputField = UITextField()
        commentInputField.delegate = self
        commentInputField.returnKeyType = UIReturnKeyType.Send;
        commentInputField.spellCheckingType = UITextSpellCheckingType.No
        commentInputField.autocorrectionType = UITextAutocorrectionType.No
        commentInputField.borderStyle = UITextBorderStyle.RoundedRect
        
        return commentInputField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.title = "有趣*朋友圈"
        
        // 设置导航栏右item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "toMakeATwitter")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(white: 0.6, alpha: 1)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 设置朋友圈header
        pengYQHeader = PengYQHeaderView(frame: CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 240))
        self.tableView.tableHeaderView = pengYQHeader
        
        pengYQHeader?.backgroundImageView?.userInteractionEnabled = true
        pengYQHeader?.backgroundImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapPengYQHeaderBackgroundView"))
        pengYQHeader?.backgroundImageView?.image = UIImage(named: "BackgroundGray")
        
        pengYQHeader?.avatarView?.userInteractionEnabled = true
        pengYQHeader?.avatarView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapPengYQHeaderAvatarView"))
        
        upRefreshControl = UpRefreshControl(scrollView: self.tableView, action: { [weak self] (control) -> Void in
            
            let strongSelf = self
            if strongSelf == nil {
                return
            }
            
            let query = strongSelf!.buildTwitterQueryWithSkip(skip: 0)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)){
                [weak strongSelf] in
                let stronggSelf = strongSelf
                if stronggSelf == nil {
                    return
                }
                let twitterResults = stronggSelf!.queryPengYQTwitterWithSkip(skip: 0)
                if stronggSelf == nil {
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                    stronggSelf!.upRefreshControl?.finishedLoadingWithStatus("", delay: 0)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if twitterResults?.count > 0 {
                        stronggSelf!.twitters = twitterResults!
                    } else {
                        stronggSelf!.twitters.removeAll(keepCapacity: false)
                    }
                    stronggSelf!.tableView.reloadData()
                }
            }
        })
        tableView.addSubview(upRefreshControl!)
        
        upLoadMoreControl = UpLoadMoreControl(scrollView: self.tableView, action: {
            
            [weak self] (control) -> Void in
            
            let strongSelf = self
            if strongSelf == nil {
                return
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)){
                [weak strongSelf] in
                let stronggSelf = strongSelf
                if stronggSelf == nil {
                    return
                }
                let twitterResults = stronggSelf!.queryPengYQTwitterWithSkip(skip: stronggSelf!.twitters.count)
                if stronggSelf == nil {
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                    stronggSelf!.upLoadMoreControl?.finishedLoadingWithStatus("", delay: 0)
                }
                
                if twitterResults?.count > 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        let orginCount = stronggSelf!.twitters.count
                        let newQueryCount = (twitterResults?.count)!
                        var insetsIndexPaths = [NSIndexPath]()
                        for index in 0...(newQueryCount - 1) {
                            insetsIndexPaths.append(NSIndexPath(forRow: orginCount + index, inSection: 0))
                        }
                        
                        stronggSelf!.twitters += twitterResults!
                        
                        stronggSelf!.tableView.insertRowsAtIndexPaths(insetsIndexPaths, withRowAnimation: UITableViewRowAnimation.None);
                    }
                }
            }
        })
        tableView.addSubview(upLoadMoreControl!)
        
        // 添加fakeCommentInputField到视图
        tableView.addSubview(fakeCommentInputField)
        
        loginUser = AVUser.currentUser()
        
        var showAvatarURL: NSURL?
        let lastPlayedRoleAvatars = loginUser?.getUserRoleAvatars()
        if lastPlayedRoleAvatars?.count > 0 {
            showAvatarURL = NSURL(string: lastPlayedRoleAvatars!.first!)
        }
        updateAvatarRelativeViewWithAvatarURL(showAvatarURL)
    }

    override func didReceiveMemoryWarning() {
        twitters.removeAll(keepCapacity: false)
    }
    
    /**
    构建动态查新对象
    
    :param: skip
    :param: limit
    
    :returns:
    */
    private func buildTwitterQueryWithSkip(skip: Int = 0, limit: Int = WSPengYQVCTwitterPageNumber) -> AVQuery {
        let query = AVQuery(className: WSTwitter.parseClassName())
        query!.skip = skip
        query!.limit = limit
        
        let queryIncludeKeys = WSTwitter.PengYQTwitterQueryIncludeKeys()
        for key in queryIncludeKeys {
            query.includeKey(key)
        }
        
        return query
    }
    
    /**
    构建动态评论的查询对象
    
    :returns:
    */
    private func buildTwitterCommentQuery() -> AVQuery {
        let query = AVQuery(className: WSTwitterComment.parseClassName())
        
        let queryIncludekeys = WSTwitterComment.PengYQTwitterCommentQueryIncludeKeys()
        for key in queryIncludekeys {
            query.includeKey(key)
        }
        
        return query
    }
    
    /**
    查询朋友圈动态
    
    :param: skip
    :param: limit
    
    :returns:
    */
    private func queryPengYQTwitterWithSkip(skip: Int = 0, limit: Int = WSPengYQVCTwitterPageNumber) -> [WSTwitter]? {
        
        let query = buildTwitterQueryWithSkip(skip: skip, limit: limit)
        let twitters = query.findObjects() as? [WSTwitter]
        
        if twitters?.count > 0 {
            for twitter in twitters! {
                // 查询评论的完整信息
                if let twitterComments = twitter.comments {
                    var completeComments = [WSTwitterComment]()
                    for comment in twitterComments {
                        let commentQuery = buildTwitterCommentQuery()
                        if let completeComment = commentQuery.getObjectWithId(comment.objectId) as? WSTwitterComment {
                            completeComments.append(completeComment)
                        } else {
                            completeComments.append(comment)
                        }
                    }
                    twitter.comments = completeComments
                }
            }
        }
        
        return twitters
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstAppear == false {
            firstAppear = true
            
            SVProgressHUD.showWithStatus("努力加载...", maskType: SVProgressHUDMaskType.Black)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)){
                [weak self] in
                let strongSelf = self
                if strongSelf == nil {
                    return
                }
                let twitterResults = strongSelf!.queryPengYQTwitterWithSkip(skip: 0)
                if strongSelf == nil {
                    return
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    SVProgressHUD.dismiss()
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if twitterResults?.count > 0 {
                        strongSelf!.twitters = twitterResults!
                    } else {
                        strongSelf!.twitters.removeAll(keepCapacity: false)
                    }
                    strongSelf!.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return twitters.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return WSTwitterCell.cellHeightWithData(data: buildTwitterCellDataWithWSTwitter(twitters[indexPath.row]), cellWidth: CGRectGetWidth(tableView.bounds))
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WSTwitterCell", forIndexPath: indexPath) as! WSTwitterCell

        cell.showTopSeperator = (indexPath.row != 0)
        cell.delegate = self
        cell.configWithData(data: buildTwitterCellDataWithWSTwitter(twitters[indexPath.row]), cellWidth: CGRectGetWidth(tableView.bounds))

        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        upRefreshControl?.scrollViewDidScroll()
        upLoadMoreControl?.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        upRefreshControl?.scrollViewDidEndDragging()
        upLoadMoreControl?.scrollViewDidEndDragging()
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        commentFiledResignFirstResponder()
    }

    // MARK: - WSRoleSelectVCDelegate
    
    func roleSelectVC(vc:WSRoleSelectVC, didSelectRole:WSRole) {
        self.navigationController?.popViewControllerAnimated(true)
        println("didSelectRole:\(didSelectRole)")
        
        let loginUser = AVUser.currentUser()
        if loginUser != nil {
            // 更新资料
            loginUser.setUserRoleObjectId(didSelectRole.objectId)
            loginUser.setUserRoleName(didSelectRole.FRoleName)
            loginUser.setUserRoleDesp(didSelectRole.FRoleDesp)
            loginUser.setUserRoleAvatars(didSelectRole.FRoleAvatars)
            
            SVProgressHUD.showWithStatus("角色变换...", maskType: SVProgressHUDMaskType.Black)
            
            // 更新用户信息
            loginUser!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    AVUser.changeCurrentUser(loginUser, save: true)
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        if let strongSelf = self {
                            strongSelf.loginUser = loginUser
                            SVProgressHUD.showSuccessWithStatus("角色变换成功", maskType: SVProgressHUDMaskType.Black)
                            let roleAvatarUrls = didSelectRole.FRoleAvatars
                            let avatarURL = (roleAvatarUrls?.count > 0) ?NSURL(string: roleAvatarUrls![0]):nil
                            strongSelf.updateAvatarRelativeViewWithAvatarURL(avatarURL)
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        SVProgressHUD.showErrorWithStatus("角色变换失败", maskType: SVProgressHUDMaskType.Black)
                    }
                }
            })
        } else {
            // 需要登录
            let newUser = AVUser()
            newUser.username = NSUUID().UUIDString
            newUser.password = "simple password"
            newUser.setUserRoleObjectId(didSelectRole.objectId)
            newUser.setUserRoleName(didSelectRole.FRoleName)
            newUser.setUserRoleDesp(didSelectRole.FRoleDesp)
            newUser.setUserRoleAvatars(didSelectRole.FRoleAvatars)
            
            SVProgressHUD.showWithStatus("角色变换...", maskType: SVProgressHUDMaskType.Black)
            
            // 新建用户
            newUser.signUpInBackgroundWithBlock({ [weak self] (success, error) -> Void in
                if let strongSelf = self {
                    if success {
                        AVUser.changeCurrentUser(newUser, save: true)
                        dispatch_async(dispatch_get_main_queue()) { [weak self] in
                            if let strongSelf = self {
                                strongSelf.loginUser = newUser
                                SVProgressHUD.showSuccessWithStatus("角色变换成功", maskType: SVProgressHUDMaskType.Black)
                                let roleAvatarUrls = didSelectRole.FRoleAvatars
                                let avatarURL = (roleAvatarUrls?.count > 0) ?NSURL(string: roleAvatarUrls![0]):nil
                                strongSelf.updateAvatarRelativeViewWithAvatarURL(avatarURL)
                            }
                        }
                    } else {
                        println("New user save error:\(error?.localizedFailureReason)")
                        dispatch_async(dispatch_get_main_queue()) {
                            SVProgressHUD.showSuccessWithStatus("角色变换失败", maskType: SVProgressHUDMaskType.Black)
                        }
                    }
                }
            })
        }
    }

    // MARK: - WSTwitterCellDelegate
    
    func twitterCell(twitterCell: WSTwitterCell, didClickMoreOprateButton: UIButton) {
        
        println("点击了操作图标，弹出操作视图")
        if let operateCellIndexPath = tableView.indexPathForRowAtPoint(tableView.convertPoint(CGPointZero, fromView: twitterCell)) {
            println("操作所在索引: \(operateCellIndexPath.row)")
            
            // 记录操作所在元素的索引
            if twitterOperatingIndexPaths?.operateTwitterIndexPath != operateCellIndexPath {
                realCommentInputField.text = nil
            }
            
            twitterOperatingIndexPaths = TwitterOperateIndexPaths(operateTwitterIndexPath: operateCellIndexPath)
            realCommentInputField.placeholder = "说点什么?"
            
            let buttonBounds = didClickMoreOprateButton.bounds
            let operateButnCenterYOriginPointAtRootView = tableView.window!.convertPoint(CGPointMake(CGRectGetMinX(buttonBounds), CGRectGetMidY(buttonBounds)), fromView: didClickMoreOprateButton)
            
            let operateViewIntrinsicContentSize = self.twitterOperateView.intrinsicContentSize()
            self.twitterOperateView.frame = CGRectMake(operateButnCenterYOriginPointAtRootView.x - operateViewIntrinsicContentSize.width, operateButnCenterYOriginPointAtRootView.y - operateViewIntrinsicContentSize.height/CGFloat(2), operateViewIntrinsicContentSize.width, operateViewIntrinsicContentSize.height)
            
            self.twitterOperateModelWindow.showWithAnimated(true)
        }
    }
    
    func twitterCell(twitterCell: WSTwitterCell, didSelectPhotoViewAtIndex: Int) {
        // TODO:
        println("点击了图片, index:\(didSelectPhotoViewAtIndex)")
    }
    
    // MARK: - TwitterCommentShowViewDelegate
    
    func twitterCommentShowView(view: TwitterCommentShowView, didSelectCommentIndex: Int) {
        
        // 获取点击的twitter所在索引
        let twitterIndexPath = tableView.indexPathForRowAtPoint(tableView.convertPoint(CGPointZero, fromView: view))
        
        if twitterIndexPath != nil && twitters.count > twitterIndexPath?.row {
            
            var placeholder = "回复"
            
            let operateTwitter = twitters[twitterIndexPath!.row]
            let operateTwitterComments = operateTwitter.comments
            
            if operateTwitterComments?.count > didSelectCommentIndex {
                let operateComment = operateTwitterComments![didSelectCommentIndex]
                if let commentUserName = operateComment.author?.getUserRoleName() {
                    placeholder += (" " + commentUserName)
                }
            }
            placeholder += ":"
            
            realCommentInputField.text = nil
            realCommentInputField.placeholder = placeholder
            
            // 改变操作行
            twitterOperatingIndexPaths = TwitterOperateIndexPaths(operateTwitterIndexPath: twitterIndexPath!, operateCommentIndexPath: NSIndexPath(forRow: didSelectCommentIndex, inSection: 0))
            
            if (fakeCommentInputField.becomeFirstResponder()) {
                realCommentInputField.becomeFirstResponder()
            }
        }
    }
    
    func twitterCommentShowView(view: TwitterCommentShowView, didSelectCommentUserName: String) {
        // TODO:
        println("didSelectCommentUserName: \(didSelectCommentUserName)")
    }
    
    func twitterCommentShowView(view: TwitterCommentShowView, didSelectZanUserName: String, atIndex: Int) {
        // TODO:
        println("didSelectZanUserName: \(didSelectZanUserName)")
    }
    
    
    // MARK: - LvModelWindowDelegate
    
    func modelWindowDidShow(modelWindow: LvModelWindow!) {
    
    }
    
    func modelWindowDidDismiss(modelWindow: LvModelWindow!) {
        
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == realCommentInputField {
            
            commentFiledResignFirstResponder()
            let comment = textField.text
            
            if comment.isEmpty == false {
                
                let twitterOperatingIndexPath = twitterOperatingIndexPaths?.operateTwitterIndexPath
                
                if twitterOperatingIndexPath != nil && twitters.count > twitterOperatingIndexPath!.row {
                    let operateTwitter = twitters[twitterOperatingIndexPath!.row]
                    let newComment = WSTwitterComment()
                    newComment.author = loginUser
                    newComment.content = comment
                    
                    // 避免循环引用Pointer，使用AVOvject的init(withoutDataWithClassName:objectId:)初始化方法
                    newComment.twitter = AVObject(withoutDataWithClassName:WSTwitter.parseClassName(), objectId:operateTwitter.objectId) as? WSTwitter
                    
                    if let twitterCommentingIndexPath = twitterOperatingIndexPaths?.operateCommentIndexPath {
                        let operateTwitterComments = operateTwitter.comments
                        if operateTwitterComments?.count > twitterCommentingIndexPath.row {
                            let operateComment = operateTwitterComments![twitterCommentingIndexPath.row]
                            newComment.atUser = operateComment.author
                        }
                    }
                    
                    operateTwitter.addUniqueObject(newComment, forKey: WSTwitter.WSTwitterKey_comments)
                    self.tableView.reloadRowsAtIndexPaths([twitterOperatingIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
                
                    // 发送评论到服务端
                    newComment.saveInBackgroundWithBlock({ [weak operateTwitter] (success, error) -> Void in
                        if let strongOperateTwitter = operateTwitter {
                            strongOperateTwitter.saveInBackground()
                        }
                    })
                    
                    realCommentInputField.text = nil
                }
            }
        }
        return true
    }
        
    private func commentFiledResignFirstResponder() {
        if realCommentInputField.isFirstResponder() {
            realCommentInputField.resignFirstResponder()
        }
        if fakeCommentInputField.isFirstResponder() {
            fakeCommentInputField.resignFirstResponder()
        }
    }
    
    
    /**
    根据动态信息创建cell需要的数据
    
    :param: twitter
    
    :returns:
    */
    private func buildTwitterCellDataWithWSTwitter(twitter: WSTwitter) -> [String: AnyObject] {

        
        var cellData = [String: AnyObject]()
        
        if let tContent = twitter.content {
            cellData[WSTwitterCellTwitterDataKey_textContent] = tContent
        }
        
        if let tPictures = twitter.pictures {
            var photoURLs = [NSURL]()
            for url in tPictures {
                if let URL = NSURL(string: url) {
                    photoURLs.append(URL)
                }
            }
            cellData[WSTwitterCellTwitterDataKey_photoURLs] = photoURLs
        }
        
        if let tAuthor = twitter.author {
            if let authorName = tAuthor.getUserRoleName() {
                cellData[WSTwitterCellTwitterDataKey_authorName] = authorName
            }
            
            if let authorAvatars = tAuthor.getUserRoleAvatars() {
                if authorAvatars.count > 0 {
                    if let avatarURL = NSURL(string: authorAvatars[0]) {
                        cellData[WSTwitterCellTwitterDataKey_avatarURL] = avatarURL
                    }
                }
            }
        }
        
        cellData[WSTwitterCellTwitterDataKey_createDate] = twitter.createdAt
        
        // 设置评论
        if let comments = twitter.comments {
            var commentsData = [[String: AnyObject]]()
            
            for comment in comments {
                var commentData = [String: AnyObject]()
                
                if let commentAuthorRoleName = comment.author?.getUserRoleName() {
                    commentData[WSTwitterCellCommentDataKey_authorName] = commentAuthorRoleName
                }
                
                if let commentAtUserRoleName = comment.atUser?.getUserRoleName() {
                    commentData[WSTwitterCellCommentDataKey_atUserName] = commentAtUserRoleName
                }
                
                if let commentText = comment.content {
                    commentData[WSTwitterCellCommentDataKey_textContent] = commentText
                }
                
                commentsData.append(commentData)
            }
            
            cellData[WSTwitterCellTwitterDataKey_comments] = commentsData
        }
        
        if let tLikes = twitter.likes {
            var zanUserRoleNames = [String]()
            
            for tLike in tLikes {
                if let roleName = tLike.getUserRoleName() {
                    zanUserRoleNames.append(roleName)
                }
            }
            
            cellData[WSTwitterCellTwitterDataKey_zanUserNames] = zanUserRoleNames
        }
        
        return cellData
    }
    
    private func updateAvatarRelativeViewWithAvatarURL(avatarURL: NSURL?) {
        self.navigationItem.leftBarButtonItem = createAvatarBarButtonItemWithAvatarURL(avatarURL, target:self, action: "clickAtRoleAvatarBarItem")
        
        if avatarURL != nil {
             pengYQHeaderAvatarViewRetrieveImageTask = pengYQHeader?.avatarView?.kf_setImageWithURL(avatarURL!, placeholderImage: UIImage(named: "RoleAvatar"))
        } else {
            pengYQHeaderAvatarViewRetrieveImageTask?.cancel()
            pengYQHeader?.avatarView?.image = UIImage(named: "RoleAvatar")
        }
    }
    
    // MARK: - Private methods
    
    private func createAvatarBarButtonItemWithAvatarURL(avatarURL:NSURL?, target: AnyObject?, action: Selector?) -> UIBarButtonItem {
        
        let customButn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        customButn.bounds = CGRectMake(0, 0, 32, 32)
        
        if avatarURL != nil {
            avatarBarButtonRetrieveImageTask = customButn.kf_setImageWithURL(avatarURL!, forState: UIControlState.Normal, placeholderImage: UIImage(named: "RoleAvatar"), optionsInfo: nil, progressBlock: nil, completionHandler: { [weak customButn] (image, error, cacheType, imageURL) -> () in
                if let strongCustomButn = customButn {
                    if image != nil {
                        strongCustomButn.setImage(Toucan.Mask.maskImageWithEllipse(image!), forState: UIControlState.Normal)
                    }
                }
            })
        } else {
            avatarBarButtonRetrieveImageTask?.cancel()
            customButn.setImage(UIImage(named: "RoleAvatar"), forState: UIControlState.Normal)
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
    
    /**
    处理点赞
    */
    @objc private func doOperateViewZan() {
        
        println("点击了赞按钮")
        
        twitterOperateModelWindow.dismissWithAnimated(true)
        
        if loginUser == nil {
            SVProgressHUD.showErrorWithStatus("请登录后再点赞", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        let twitterOperatingIndexPath = twitterOperatingIndexPaths?.operateTwitterIndexPath
        
        if twitterOperatingIndexPath != nil && twitters.count > twitterOperatingIndexPath!.row {
            let operateTwitter = twitters[twitterOperatingIndexPath!.row]

            operateTwitter.addUniqueObject(loginUser, forKey: WSTwitter.WSTwitterKey_likes)
            
            self.tableView.reloadRowsAtIndexPaths([twitterOperatingIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
            
            // 发送赞到服务器端
            operateTwitter.saveInBackground()
        }
    }
    
    @objc private func doOperateViewComment() {
        
        println("点击了评论按钮")
        
        twitterOperateModelWindow.dismissWithAnimated(true)
        
        if loginUser == nil {
            SVProgressHUD.showErrorWithStatus("请登录后再评论", maskType: SVProgressHUDMaskType.Black)
            return
        }
        
        let twitterOperatingIndexPath = twitterOperatingIndexPaths?.operateTwitterIndexPath
        
        if twitterOperatingIndexPath != nil && twitters.count > twitterOperatingIndexPath!.row {
            if fakeCommentInputField.becomeFirstResponder() {
                realCommentInputField.becomeFirstResponder()
            }
        }
    }
    
    @objc private func dismissTwitterOperateModelWindow() {
        twitterOperateModelWindow.dismissWithAnimated(true)
    }
}

let WSPengYQVCTwitterPageNumber = 5
