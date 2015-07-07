//
//  DongTai.swift
//  Wukong
//
//  Created by guangbo on 15/7/3.
//
//

import UIKit
import AVOSCloud

/**
*  动态
*/
class DongTai: AVObject {
    var content:String?
    var pictures: [ImageInfo]?
    var author:AVUser?
    var comments: [DongTai]?
    var parent:DongTai?
    var likes:[Like]?
    var unlikes:[Unlike]?
    
    func initWithContent(mContent:String?, pictures mPictures:[ImageInfo]?, author mAuthor:AVUser?, comments mComments:[DongTai]?, parent mParent:DongTai?, likes mLikes:[Like]?, unlikes mUnlikes:[Unlike]?)
    {
        content = mContent
        pictures = mPictures
        author = mAuthor
        comments = mComments
        parent = mParent
        likes = mLikes
        unlikes = mUnlikes
    }
}
