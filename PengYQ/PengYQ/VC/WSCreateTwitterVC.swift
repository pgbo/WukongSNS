//
//  WSCreateTwitterVC.swift
//  PengYQ
//
//  Created by 彭光波 on 15/7/11.
//
//

import UIKit
import CTAssetsPickerController

/// 发推vc
class WSCreateTwitterVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CTAssetsPickerControllerDelegate {
    
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
            contentView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            textView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            collectionView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            stateLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            // 设置约束
            let views = ["contentView": contentView!, "textView": textView!, "collectionView": collectionView!, "stateLabel": stateLabel!]
            
            let metrics = ["photoHeight": albumAddBtnImage.size.height]
            
            // 设置contentView的约束
            self.view.addConstraint(NSLayoutConstraint(item: contentView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
            
            // 设置textView的约束
            contentView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[textView(120)]-8-[collectionView(photoHeight)]-8-[stateLabel(20)]|", options: NSLayoutFormatOptions.AlignAllLeading|NSLayoutFormatOptions.AlignAllTrailing, metrics: metrics, views: views))
            contentView!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[textView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
            
            
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
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AddPhotoButtonCellReusableIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
            
            if cell.viewWithTag(AddPhotoButtonCellButtonTag) == nil {
                let addPhotoButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                cell.contentView.addSubview(addPhotoButton)
                
                addPhotoButton.tag = AddPhotoButtonCellButtonTag
                addPhotoButton.setImage(albumAddBtnImage, forState: UIControlState.Normal)
                addPhotoButton.setImage(albumAddBtnHLImage, forState: UIControlState.Highlighted)
                addPhotoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                let views = ["addPhotoButton": addPhotoButton]
                
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[addPhotoButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[addPhotoButton]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
                
                addPhotoButton.addTarget(self, action:"clickAddPhotoButn", forControlEvents:UIControlEvents.TouchUpInside)
                
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AttachTwitterPhotoCellReusableIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
            
            var attachImageView = cell.viewWithTag(AttachTwitterPhotoCellImageViewTag) as? UIImageView
            
            if attachImageView == nil {
                attachImageView = UIImageView()
                cell.contentView.addSubview(attachImageView!)
                
                attachImageView?.setTranslatesAutoresizingMaskIntoConstraints(false)
                attachImageView?.clipsToBounds = true
                attachImageView?.tag = AttachTwitterPhotoCellImageViewTag
                attachImageView?.contentMode = UIViewContentMode.ScaleAspectFill
                
                let views = ["attachImageView": attachImageView!]
                
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[attachImageView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[attachImageView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
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
        
        collectionView?.reloadData()
    }
    
    func assetsPickerControllerDidCancel(picker: CTAssetsPickerController!) {
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func assetsPickerController(picker: CTAssetsPickerController!, shouldSelectAsset asset: ALAsset!) -> Bool {
        
        if picker.selectedAssets.count > 9 {
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
        
        
        self.view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
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
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16)
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
        
        // Warming: 在viewDidLayoutSubviews里设置约束
    }
    
    
    @objc private func clickAddPhotoButn() {
        self.presentViewController(assetsPickerController, animated: true, completion: nil)
    }
    
    @objc private func requestCreateTwitter() {
        // TODO:
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

let AddPhotoButtonCellButtonTag = 100
let AddPhotoButtonCellReusableIdentifier = "AddPhotoButtonCell"
let AttachTwitterPhotoCellImageViewTag = 100
let AttachTwitterPhotoCellReusableIdentifier = "AttachTwitterPhotoCell"

