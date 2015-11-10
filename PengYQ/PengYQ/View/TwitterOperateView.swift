//
//  TwitterOperateView.swift
//  PengYQ
//
//  Created by guangbo on 15/7/13.
//
//

import UIKit

class TwitterOperateView: UIView {

    private var bkgImageView: UIImageView?
    private(set) var zanButton: UIButton?
    private var seperatorView: UIView?
    private(set) var commentButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTwitterOperateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTwitterOperateView()
    }
    
    override func intrinsicContentSize() -> CGSize {
        // 返回视图natural尺寸
        return CGSizeMake(132.5, 39)
    }
    
    private func setupTwitterOperateView() {
        
        bkgImageView = UIImageView(image: UIImage(named: "AlbumOperateViewBkg")?.resizableImageWithCapInsets(UIEdgeInsetsMake(6, 6, 6, 6)))
        self.addSubview(bkgImageView!)
        
        bkgImageView?.translatesAutoresizingMaskIntoConstraints = false
        var views: [String: UIView] = ["bkgImageView":bkgImageView!]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bkgImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bkgImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        
        zanButton = UIButton(type: UIButtonType.Custom) as? UIButton
        self.addSubview(zanButton!)
        
        let likeIcon = UIImage(named: "AlbumLikeWhite")
        zanButton?.translatesAutoresizingMaskIntoConstraints = false
        zanButton?.setImage(likeIcon, forState: UIControlState.Normal)
        zanButton?.setImage(likeIcon, forState: UIControlState.Highlighted)
        zanButton?.setTitle("赞", forState: UIControlState.Normal)
        zanButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        
        seperatorView = UIView()
        self.addSubview(seperatorView!)
        
        seperatorView?.translatesAutoresizingMaskIntoConstraints = false
        seperatorView?.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8)
        
        
        commentButton = UIButton(type: UIButtonType.Custom) as? UIButton
        self.addSubview(commentButton!)
        
        let commentIcon = UIImage(named: "AlbumCommentWhite")
        commentButton?.translatesAutoresizingMaskIntoConstraints = false
        commentButton?.setImage(commentIcon, forState: UIControlState.Normal)
        commentButton?.setImage(commentIcon, forState: UIControlState.Highlighted)
        commentButton?.setTitle("评论", forState: UIControlState.Normal)
        commentButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        
        views = ["zanButton": zanButton!, "seperatorView": seperatorView!, "commentButton": commentButton!]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-6-[zanButton(54)]-3-[seperatorView(0.5)]-3-[commentButton(60)]-6-|", options: [NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: nil, views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-6-[zanButton]-6-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
    }
}

//@objc protocol TwitterOperateViewDelegate {
//    
//    optional func didClickZanButton(atTwitterOperateView operateView: TwitterOperateView)
//    
//    optional func didClickCommentButton(atTwitterOperateView operateView: TwitterOperateView)
//}
