//
//  TwitterCommentShowView.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/9.
//
//

import UIKit

/// 动态评论展示视图
class TwitterCommentShowView: UIView {

    // TODO: 根据数据计算高度
    // 提供delegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTwitterCommentShowView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTwitterCommentShowView()
    }
    
    private func setupTwitterCommentShowView() {
    
    }

}
