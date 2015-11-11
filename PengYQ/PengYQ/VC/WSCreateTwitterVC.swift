//
//  WSCreateTwitterVC.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/11.
//
//

import UIKit
import CTAssetsPickerController
import SVProgressHUD
import AVOSCloud
import Toucan
import Haneke

/// 发推vc
class WSCreateTwitterVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CTAssetsPickerControllerDelegate {
    
    private var controlBackgroud: UIControl?
    private var contentView: UIView?
    private var textView: UITextView?
    private var collectionView: UICollectionView?
    private var stateLabel: UILabel?
    
    private var hasSetupSubviewConstraints: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCreateTwitterVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if hasSetupSubviewConstraints == false {
            controlBackgroud?.translatesAutoresizingMaskIntoConstraints = false
            contentView?.translatesAutoresizingMaskIntoConstraints = false
            textView?.translatesAutoresizingMaskIntoConstraints = false
            collectionView?.translatesAutoresizingMaskIntoConstraints = false
            stateLabel?.translatesAutoresizingMaskIntoConstraints = false
            
            // 设置约束
            let views = ["controlBackgroud":controlBackgroud!, "contentView": contentView!, "textView": textView!, "collectionView": collectionView!, "stateLabel": stateLabel!]
            
            let metrics = ["photoHeight": albumAddBtnImage.size.height]
            
            // 设置controlBackgroud的约束
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[controlBackgroud]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[controlBackgroud]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            
            // 设置contentView的约束
            self.view.addConstraint(NSLayoutConstraint(item: contentView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            
            // 设置textView的约束
            contentView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[textView(120)]-8-[collectionView(photoHeight)]-16-[stateLabel(20)]-20-|", options: [NSLayoutFormatOptions.AlignAllLeading, NSLayoutFormatOptions.AlignAllTrailing], metrics: metrics, views: views))
            
            contentView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[textView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            
            contentView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[collectionView]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            
            
            hasSetupSubviewConstraints = true
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 选中的图片 ＋ 一个添加按钮
        return assetsPickerController.selectedAssets.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row == assetsPickerController.selectedAssets.count {
            // 添加图片按钮cell
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AddPhotoButtonCellReusableIdentifier, forIndexPath: indexPath) 
            
            if cell.contentView.viewWithTag(AddPhotoButtonCellButtonTag) == nil {
                let addPhotoButton = UIButton(type: UIButtonType.Custom)
                cell.contentView.addSubview(addPhotoButton)
                
                addPhotoButton.tag = AddPhotoButtonCellButtonTag
                addPhotoButton.setImage(albumAddBtnImage, forState: UIControlState.Normal)
                addPhotoButton.setImage(albumAddBtnHLImage, forState: UIControlState.Highlighted)
                addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
                let views = ["addPhotoButton": addPhotoButton]
                
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[addPhotoButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[addPhotoButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
                
                addPhotoButton.addTarget(self, action:"clickAddPhotoButn", forControlEvents:UIControlEvents.TouchUpInside)
                
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AttachTwitterPhotoCellReusableIdentifier, forIndexPath: indexPath) 
            
            var attachImageView = cell.contentView.viewWithTag(AttachTwitterPhotoCellImageViewTag) as? UIImageView
            
            if attachImageView == nil {
                attachImageView = UIImageView()
                cell.contentView.addSubview(attachImageView!)
                
                attachImageView!.translatesAutoresizingMaskIntoConstraints = false
                attachImageView?.clipsToBounds = true
                attachImageView?.tag = AttachTwitterPhotoCellImageViewTag
                attachImageView?.contentMode = UIViewContentMode.ScaleAspectFill
                
                let views = ["attachImageView": attachImageView!]
                
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[attachImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[attachImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            }
            
            let asset:ALAsset = assetsPickerController.selectedAssets[indexPath.row] as! ALAsset
            
            let image = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue(), scale: 1, orientation: UIImageOrientation.Up)
            
            attachImageView?.image = image
            
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < assetsPickerController.selectedAssets.count {
            self.presentViewController(assetsPickerController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - CTAssetsPickerControllerDelegate
    
    func assetsPickerController(picker: CTAssetsPickerController!, isDefaultAssetsGroup group: ALAssetsGroup!) -> Bool {
        return group.valueForProperty(ALAssetsGroupPropertyType).isEqual(Int(ALAssetsGroupSavedPhotos))
    }
    
    func assetsPickerController(picker: CTAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        let selectedAssetsCount = assets.count
        stateLabel?.text = WSCreateTwitterVC.description(x_photosSelected:selectedAssetsCount, y_photosRemain:TwitterUploadPhotoMaxNumber - selectedAssetsCount)
        
        collectionView?.reloadData()
    }
    
    func assetsPickerControllerDidCancel(picker: CTAssetsPickerController!) {
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func assetsPickerController(picker: CTAssetsPickerController!, shouldSelectAsset asset: ALAsset!) -> Bool {
        
        if picker.selectedAssets.count >= 9 {
            let alert = UIAlertView(title: nil, message: "最多选择9张图片", delegate: nil, cancelButtonTitle: "知道了")
            alert.show()
            return false
        }
        return true
    }
    
    func assetsPickerController(picker: CTAssetsPickerController!, didSelectAsset asset: ALAsset!) {
    
    }
    
    func assetsPickerController(picker: CTAssetsPickerController!, shouldDeselectAsset asset: ALAsset!) -> Bool {
        return true
    }
    
    func assetsPickerController(picker: CTAssetsPickerController!, didDeselectAsset asset: ALAsset!) {
    
    }
    
    private func setupCreateTwitterVC() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 设置nav bar button item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelCreateTwitter")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发表", style: UIBarButtonItemStyle.Plain, target: self, action: "requestCreateTwitter")
        self.navigationItem.title = "发表动态"
        
        
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        controlBackgroud = UIControl()
        self.view.addSubview(controlBackgroud!)
        
        controlBackgroud?.addTarget(self, action: "hideKeyboard", forControlEvents: UIControlEvents.TouchDown)
        
        // 设置contentView
        contentView = UIView()
        self.view.addSubview(contentView!)
        
        contentView?.backgroundColor = UIColor.whiteColor()
        
        
        // 设置textView
        textView = UITextView()
        contentView!.addSubview(textView!)
        
        textView?.backgroundColor = UIColor.whiteColor()
        textView?.editable = true
        textView?.scrollEnabled = false
        textView?.showsHorizontalScrollIndicator = false
        textView?.showsVerticalScrollIndicator = false
        
        
        // 设置collectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = albumAddBtnImage.size
        flowLayout.minimumLineSpacing = 8
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        contentView!.addSubview(collectionView!)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:AddPhotoButtonCellReusableIdentifier)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:AttachTwitterPhotoCellReusableIdentifier)
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.alwaysBounceVertical = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        // 设置stateLabel
        stateLabel = UILabel()
        contentView!.addSubview(stateLabel!)
        
        stateLabel?.backgroundColor = UIColor.whiteColor()
        stateLabel?.textAlignment = NSTextAlignment.Center
        stateLabel?.font = UIFont.systemFontOfSize(15)
        stateLabel?.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        
        stateLabel?.text = WSCreateTwitterVC.description(x_photosSelected:0, y_photosRemain:TwitterUploadPhotoMaxNumber)
        
        // Warming: 在viewDidLayoutSubviews里设置约束
    }
    
    static private func description(x_photosSelected x: Int = 0, y_photosRemain y: Int = 0) -> String {
        return "已选\(x)张，还可以添加\(y)张"
    }
    
    @objc private func clickAddPhotoButn() {
        self.presentViewController(assetsPickerController, animated: true, completion: nil)
    }
    
    /**
    发表动态
    */
    @objc private func requestCreateTwitter() {
        
        textView?.resignFirstResponder()
        
        if AVUser.currentUser() != nil {
            
            // 已经在试用登录
            
            let selectedPhotoCount = assetsPickerController.selectedAssets.count
            let textEmpty = textView?.text.isEmpty
            if selectedPhotoCount == 0 && textEmpty == true {
                SVProgressHUD.showErrorWithStatus("没有填写动态信息或添加照片", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            SVProgressHUD.showWithStatus("请稍后...", maskType: SVProgressHUDMaskType.Black)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [weak self] in
                
                if let strongSelf = self {
                    
                    // 上传图片
                    var photoUrls = [String]()
                    let selectedAssets = strongSelf.assetsPickerController.selectedAssets
                    if selectedAssets?.count > 0 {
                        for asset in selectedAssets {
                            let image = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue(), scale: 1, orientation: UIImageOrientation.Up)
                            let uploadImageSize = suitableSizeForTwitterUploadImageSize(image.size)
                            let uploadImage = Toucan(image: image).resize(uploadImageSize, fitMode: Toucan.Resize.FitMode.Clip).image
                            let uploadFile = AVFile(data: uploadImage.asData())
                            
                            var error: NSError?
                            if uploadFile.save(&error) {
                                if uploadFile.url != nil {
                                    photoUrls.append(uploadFile.url)
                                }
                            } else {
                                print("Upload twitter photo error:\(error?.localizedFailureReason)")
                            }
                        }
                    }
                    
                    // 上传动态
                    let newTwitter = WSTwitter()
                    
                    newTwitter.content = strongSelf.textView?.text
                    newTwitter.pictures = photoUrls
                    newTwitter.author = AVUser.currentUser()
                    
                    var error: NSError?
                    do {
                        try newTwitter.save()
                        dispatch_async(dispatch_get_main_queue()) {
                            SVProgressHUD.showSuccessWithStatus("发表成功", maskType: SVProgressHUDMaskType.Black)
                            strongSelf.cancelCreateTwitter()
                        }
                    } catch let error1 as NSError {
                        error = error1
                        print("Upload twitter photo error:\(error?.localizedFailureReason)")
                        dispatch_async(dispatch_get_main_queue()) {
                            SVProgressHUD.showErrorWithStatus("发表失败，请稍后再试", maskType: SVProgressHUDMaskType.Black)
                        }
                    } catch {
                        fatalError()
                    }
                }
            }
            
        } else {
            SVProgressHUD.showErrorWithStatus("您还没有选择角色，请选择角色后再发表动态", maskType: SVProgressHUDMaskType.Black)
        }
    }
    
    @objc private func hideKeyboard() {
        textView?.resignFirstResponder()
    }
    
    @objc private func cancelCreateTwitter() {
        textView?.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    lazy var albumAddBtnImage: UIImage = {
        return UIImage(named: "AlbumAddBtn")!
    }()
    
    lazy var albumAddBtnHLImage: UIImage = {
        return UIImage(named: "AlbumAddBtnHL")!
    }()
    
    lazy var assetsPickerController: CTAssetsPickerController = {
        let picker = CTAssetsPickerController()
        picker.delegate = self
        return picker
        }()
}

let TwitterUploadPhotoMaxNumber = 9

let AddPhotoButtonCellButtonTag = 100
let AddPhotoButtonCellReusableIdentifier = "AddPhotoButtonCell"
let AttachTwitterPhotoCellImageViewTag = 100
let AttachTwitterPhotoCellReusableIdentifier = "AttachTwitterPhotoCell"

