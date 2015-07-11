//
//  WSConstants.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/11.
//
//

import Foundation
import UIKit

let uploadTwitterPhotoMaxWidth:CGFloat = 640
let uploadTwitterPhotoMaxheight:CGFloat = 800

func suitableSizeForTwitterUploadImageSize(uploadImageSize: CGSize!) -> CGSize! {
    if uploadImageSize.width <= 0 || uploadImageSize.height <= 0 {
        return uploadImageSize
    }
    
    let horizonRatio = uploadTwitterPhotoMaxWidth/uploadImageSize.width
    let verticalRatio = uploadTwitterPhotoMaxheight/uploadImageSize.height;
    var ratio: CGFloat = 1
    if (horizonRatio >= 1 || verticalRatio >= 1) {
        ratio = 1
    } else {
        ratio = horizonRatio < verticalRatio ?horizonRatio:verticalRatio
    }
    return CGSizeMake(ratio * uploadImageSize.width, ratio * uploadImageSize.height)
}