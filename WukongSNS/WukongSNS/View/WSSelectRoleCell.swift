//
//  WSSelectRoleCell.swift
//  WukongSNS
//
//  Created by 彭光波 on 15/7/4.
//
//

import UIKit

class WSSelectRoleCell: UITableViewCell {
    
    @IBOutlet private var topSeperator:UIView?
    @IBOutlet private var roleTextView:UITextView?
    @IBOutlet private var roleAvatarView:UIImageView?
    @IBOutlet private var selectRoleButton:UIButton?

    var showTopSeperator:Bool {
        get {
            return self.showTopSeperator
        }
        
        set(ifShow) {
            topSeperator?.hidden = !ifShow
        }
    }
    
    func configWithData(data:NSDictionary?) {
        
    }
    
    static func cellHeightWithData(data:NSDictionary?, cellWidth:Float?) ->Float {
        return 0
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topSeperator?.backgroundColor = UIColor.grayColor()
        showTopSeperator = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}


let WSSelectRoleCellData_roleNameKey = ""
