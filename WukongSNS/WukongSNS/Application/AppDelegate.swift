//
//  AppDelegate.swift
//  JinJu
//
//  Created by guangbo on 15/7/2.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置leancloud
        AVOSCloud.setApplicationId("me90srxsg78g6n2s01oqx1ncwt1k2mtx8t263ajrf3k8my7g", clientKey: "ok3pxal4n7jyy342lxq4cp95ormwn546yw25yie8crpfub0l")
        
        //如果想跟踪统计应用的打开情况，后面还可以添加下列代码
        AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
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

