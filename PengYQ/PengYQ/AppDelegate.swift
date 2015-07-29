//
//  AppDelegate.swift
//  PengYQ
//
//  Created by guangbo on 15/7/8.
//
//

import UIKit
import AVOSCloud
import AVOSCloudIM

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置leancloud
        AVOSCloud.setApplicationId("me90srxsg78g6n2s01oqx1ncwt1k2mtx8t263ajrf3k8my7g", clientKey: "ok3pxal4n7jyy342lxq4cp95ormwn546yw25yie8crpfub0l")
        
        WSTwitter.registerSubclass()
        WSTwitterComment.registerSubclass()
        WSRole.registerSubclass()
        WSRoleGroup.registerSubclass()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }


}

