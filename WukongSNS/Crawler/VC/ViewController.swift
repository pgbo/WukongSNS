//
//  ViewController.swift
//  Crawler
//
//  Created by 彭光波 on 15/7/6.
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var originRoleGroupCountLabel:UILabel?
    @IBOutlet private weak var originRoleCountLabel:UILabel?
    @IBOutlet private weak var startCrawlerButton:UIButton?
    @IBOutlet private weak var uploadDataButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCrawlerButton?.addTarget(self, action:"startCrawl", forControlEvents: UIControlEvents.TouchUpInside)
        
        uploadDataButton?.addTarget(self, action:"uploadData", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        SVProgressHUD.showWithStatus("获取原数据中...")
    }

    private func startCrawl() {
        
    }
    
    private func uploadData() {
        
    }
}

